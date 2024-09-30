{ lib, stdenv, substituteAll, fetchurl
, zlibSupport ? true, zlib
, bzip2, pkg-config, libffi, libunwind, Security
, sqlite, openssl, ncurses, python, expat, tcl, tk, tix, libX11
, gdbm, db, xz, python-setup-hook
, optimizationLevel ? "jit", boehmgc
# For the Python package set
, hash
, self
, packageOverrides ? (self: super: {})
, pkgsBuildBuild
, pkgsBuildHost
, pkgsBuildTarget
, pkgsHostHost
, pkgsTargetTarget
, sourceVersion
, pythonVersion
, passthruFun
, pythonAttr ? "pypy${lib.substring 0 1 pythonVersion}${lib.substring 2 3 pythonVersion}"
}:

assert zlibSupport -> zlib != null;

let
  isPy3k = (lib.versions.major pythonVersion) == "3";
  isPy38OrNewer = lib.versionAtLeast pythonVersion "3.8";
  isPy39OrNewer = lib.versionAtLeast pythonVersion "3.9";
  passthru = passthruFun rec {
    inherit self sourceVersion pythonVersion packageOverrides;
    implementation = "pypy";
    libPrefix = "pypy${pythonVersion}";
    executable = "pypy${if isPy39OrNewer then lib.versions.majorMinor pythonVersion else lib.optionalString isPy3k "3"}";
    sitePackages = "${lib.optionalString isPy38OrNewer "lib/${libPrefix}/"}site-packages";
    hasDistutilsCxxPatch = false;
    inherit pythonAttr;

    pythonOnBuildForBuild = pkgsBuildBuild.${pythonAttr};
    pythonOnBuildForHost = pkgsBuildHost.${pythonAttr};
    pythonOnBuildForTarget = pkgsBuildTarget.${pythonAttr};
    pythonOnHostForHost = pkgsHostHost.${pythonAttr};
    pythonOnTargetForTarget = pkgsTargetTarget.${pythonAttr} or {};
  };
  pname = passthru.executable;
  version = with sourceVersion; "${major}.${minor}.${patch}";
  pythonForPypy = python.withPackages (ppkgs: [ ]);

in with passthru; stdenv.mkDerivation rec {
  inherit pname version;

  src = fetchurl {
    url = "https://downloads.python.org/pypy/pypy${pythonVersion}-v${version}-src.tar.bz2";
    inherit hash;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    bzip2 openssl pythonForPypy libffi ncurses expat sqlite tk tcl libX11 gdbm db
  ]  ++ lib.optionals isPy3k [
    xz
  ] ++ lib.optionals (stdenv ? cc && stdenv.cc.libc != null) [
    stdenv.cc.libc
  ] ++ lib.optionals zlibSupport [
    zlib
  ] ++ lib.optionals (lib.any (l: l == optimizationLevel) [ "0" "1" "2" "3"]) [
    boehmgc
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libunwind Security
  ];

  # Remove bootstrap python from closure
  dontPatchShebangs = true;
  disallowedReferences = [ python ];

  C_INCLUDE_PATH = lib.makeSearchPathOutput "dev" "include" buildInputs;
  LIBRARY_PATH = lib.makeLibraryPath buildInputs;
  LD_LIBRARY_PATH = lib.makeLibraryPath (builtins.filter (x : x.outPath != stdenv.cc.libc.outPath or "") buildInputs);

  patches = [
    ./dont_fetch_vendored_deps.patch

    (substituteAll {
      src = ./tk_tcl_paths.patch;
      inherit tk tcl;
      tk_dev = tk.dev;
      tcl_dev = tcl;
      tk_libprefix = tk.libPrefix;
      tcl_libprefix = tcl.libPrefix;
    })

    (substituteAll {
      src = ./sqlite_paths.patch;
      inherit (sqlite) out dev;
    })
  ];

  postPatch = ''
    substituteInPlace lib_pypy/pypy_tools/build_cffi_imports.py \
      --replace "multiprocessing.cpu_count()" "$NIX_BUILD_CORES"

    substituteInPlace "lib-python/${if isPy3k then "3/tkinter/tix.py" else "2.7/lib-tk/Tix.py"}" \
      --replace "os.environ.get('TIX_LIBRARY')" "os.environ.get('TIX_LIBRARY') or '${tix}/lib'"
  '';

  buildPhase = ''
    runHook preBuild

    ${pythonForPypy.interpreter} rpython/bin/rpython \
      --make-jobs="$NIX_BUILD_CORES" \
      -O${optimizationLevel} \
      --batch pypy/goal/targetpypystandalone.py

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,include,lib,${executable}-c}

    cp -R {include,lib_pypy,lib-python,${executable}-c} $out/${executable}-c
    cp lib${executable}-c${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/
    ln -s $out/${executable}-c/${executable}-c $out/bin/${executable}
    ${lib.optionalString isPy39OrNewer "ln -s $out/bin/${executable} $out/bin/pypy3"}

    # other packages expect to find stuff according to libPrefix
    ln -s $out/${executable}-c/include $out/include/${libPrefix}
    ln -s $out/${executable}-c/lib-python/${if isPy3k then "3" else pythonVersion} $out/lib/${libPrefix}

    # Include a sitecustomize.py file
    cp ${../sitecustomize.py} $out/${if isPy38OrNewer then sitePackages else "lib/${libPrefix}/${sitePackages}"}/sitecustomize.py

    runHook postInstall
  '';

  preFixup = lib.optionalString (stdenv.hostPlatform.isDarwin) ''
    install_name_tool -change @rpath/lib${executable}-c.dylib $out/lib/lib${executable}-c.dylib $out/bin/${executable}
  '' + lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) ''
    mkdir -p $out/${executable}-c/pypy/bin
    mv $out/bin/${executable} $out/${executable}-c/pypy/bin/${executable}
    ln -s $out/${executable}-c/pypy/bin/${executable} $out/bin/${executable}
  '';

  setupHook = python-setup-hook sitePackages;

  # TODO: A bunch of tests are failing as of 7.1.1, please feel free to
  # fix and re-enable if you have the patience and tenacity.
  doCheck = false;
  checkPhase = let
    disabledTests = [
      # disable shutils because it assumes gid 0 exists
      "test_shutil"
      # disable socket because it has two actual network tests that fail
      "test_socket"
    ] ++ lib.optionals (!isPy3k) [
      # disable test_urllib2net, test_urllib2_localnet, and test_urllibnet because they require networking (example.com)
      "test_urllib2net"
      "test_urllibnet"
      "test_urllib2_localnet"
    ] ++ lib.optionals isPy3k [
      # disable asyncio due to https://github.com/NixOS/nix/issues/1238
      "test_asyncio"
      # disable os due to https://github.com/NixOS/nixpkgs/issues/10496
      "test_os"
      # disable pathlib due to https://bitbucket.org/pypy/pypy/pull-requests/594
      "test_pathlib"
      # disable tarfile because it assumes gid 0 exists
      "test_tarfile"
      # disable __all__ because of spurious imp/importlib warning and
      # warning-to-error test policy
      "test___all__"
    ];
  in ''
    export TERMINFO="${ncurses.out}/share/terminfo/";
    export TERM="xterm";
    export HOME="$TMPDIR";

    ${pythonForPypy.interpreter} ./pypy/test_all.py --pypy=./${executable}-c -k 'not (${lib.concatStringsSep " or " disabledTests})' lib-python
  '';

  # verify cffi modules
  doInstallCheck = true;
  installCheckPhase = let
    modules = [
      "curses"
      "sqlite3"
    ] ++ lib.optionals (!isPy3k) [
      "Tkinter"
    ] ++ lib.optionals isPy3k [
      "tkinter"
      "lzma"
    ];
    imports = lib.concatMapStringsSep "; " (x: "import ${x}") modules;
  in ''
    echo "Testing whether we can import modules"
    $out/bin/${executable} -c '${imports}'
  '';

  inherit passthru;
  enableParallelBuilding = true;  # almost no parallelization without STM

  meta = with lib; {
    homepage = "https://www.pypy.org/";
    description = "Fast, compliant alternative implementation of the Python language (${pythonVersion})";
    mainProgram = "pypy";
    license = licenses.mit;
    platforms = [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
    broken = optimizationLevel == "0"; # generates invalid code
    maintainers = with maintainers; [ andersk ];
  };
}
