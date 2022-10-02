{ lib, stdenv, substituteAll, fetchurl
, zlib ? null, zlibSupport ? true, bzip2, pkg-config, libffi, libunwind, Security
, sqlite, openssl, ncurses, python, expat, tcl, tk, tix, xlibsWrapper, libX11
, self, gdbm, db, xz
, python-setup-hook
# For the Python package set
, packageOverrides ? (self: super: {})
, pkgsBuildBuild
, pkgsBuildHost
, pkgsBuildTarget
, pkgsHostHost
, pkgsTargetTarget
, sourceVersion
, pythonVersion
, sha256
, passthruFun
, pythonAttr ? "pypy${lib.substring 0 1 pythonVersion}${lib.substring 2 3 pythonVersion}"
}:

assert zlibSupport -> zlib != null;

with lib;

let
  isPy3k = substring 0 1 pythonVersion == "3";
  passthru = passthruFun {
    inherit self sourceVersion pythonVersion packageOverrides;
    implementation = "pypy";
    libPrefix = "pypy${pythonVersion}";
    executable = "pypy${if isPy3k then "3" else ""}";
    sitePackages = "site-packages";
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
  pythonForPypy = python.withPackages (ppkgs: [ ppkgs.pycparser ]);

in with passthru; stdenv.mkDerivation rec {
  inherit pname version;

  src = fetchurl {
    url = "https://downloads.python.org/pypy/pypy${pythonVersion}-v${version}-src.tar.bz2";
    inherit sha256;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    bzip2 openssl pythonForPypy libffi ncurses expat sqlite tk tcl xlibsWrapper libX11 gdbm db
  ]  ++ optionals isPy3k [
    xz
  ] ++ optionals (stdenv ? cc && stdenv.cc.libc != null) [
    stdenv.cc.libc
  ] ++ optionals zlibSupport [
    zlib
  ] ++ optionals stdenv.isDarwin [
    libunwind Security
  ];

  hardeningDisable = optional stdenv.isi686 "pic";

  # Remove bootstrap python from closure
  dontPatchShebangs = true;
  disallowedReferences = [ python ];

  C_INCLUDE_PATH = makeSearchPathOutput "dev" "include" buildInputs;
  LIBRARY_PATH = makeLibraryPath buildInputs;
  LD_LIBRARY_PATH = makeLibraryPath (filter (x : x.outPath != stdenv.cc.libc.outPath or "") buildInputs);

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

    substituteInPlace "lib-python/${if isPy3k then "3/tkinter/tix.py" else "2.7/lib-tk/Tix.py"}" --replace "os.environ.get('TIX_LIBRARY')" "os.environ.get('TIX_LIBRARY') or '${tix}/lib'"
  '';

  buildPhase = ''
    ${pythonForPypy.interpreter} rpython/bin/rpython \
      --make-jobs="$NIX_BUILD_CORES" \
      -Ojit \
      --batch pypy/goal/targetpypystandalone.py
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
    ] ++ optionals (!isPy3k) [
      # disable test_urllib2net, test_urllib2_localnet, and test_urllibnet because they require networking (example.com)
      "test_urllib2net"
      "test_urllibnet"
      "test_urllib2_localnet"
    ] ++ optionals isPy3k [
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

    ${pythonForPypy.interpreter} ./pypy/test_all.py --pypy=./${executable}-c -k 'not (${concatStringsSep " or " disabledTests})' lib-python
  '';

  installPhase = ''
    mkdir -p $out/{bin,include,lib,${executable}-c}

    cp -R {include,lib_pypy,lib-python,${executable}-c} $out/${executable}-c
    cp lib${executable}-c${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/
    ln -s $out/${executable}-c/${executable}-c $out/bin/${executable}

    # other packages expect to find stuff according to libPrefix
    ln -s $out/${executable}-c/include $out/include/${libPrefix}
    ln -s $out/${executable}-c/lib-python/${if isPy3k then "3" else pythonVersion} $out/lib/${libPrefix}

    ${lib.optionalString stdenv.isDarwin ''
      install_name_tool -change @rpath/libpypy${optionalString isPy3k "3"}-c.dylib $out/lib/libpypy${optionalString isPy3k "3"}-c.dylib $out/bin/${executable}
    ''}

    # verify cffi modules
    $out/bin/${executable} -c ${if isPy3k then "'import tkinter;import sqlite3;import curses;import lzma'" else "'import Tkinter;import sqlite3;import curses'"}

    # Include a sitecustomize.py file
    cp ${../sitecustomize.py} $out/lib/${libPrefix}/${sitePackages}/sitecustomize.py
  '';

  inherit passthru;
  enableParallelBuilding = true;  # almost no parallelization without STM

  meta = with lib; {
    homepage = "http://pypy.org/";
    description = "Fast, compliant alternative implementation of the Python language (${pythonVersion})";
    license = licenses.mit;
    platforms = [ "aarch64-linux" "i686-linux" "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ andersk ];
  };
}
