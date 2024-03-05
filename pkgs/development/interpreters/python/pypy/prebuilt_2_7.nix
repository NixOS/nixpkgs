{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, python-setup-hook
, self
# Dependencies
, bzip2
, expat
, gdbm
, ncurses6
, sqlite
, tcl-8_5
, tk-8_5
, tcl-8_6
, tk-8_6
, zlib
# For the Python package set
, packageOverrides ? (self: super: {})
, sourceVersion
, pythonVersion
, hash
, passthruFun
}:

# This version of PyPy is primarily added to speed-up translation of
# our PyPy source build when developing that expression.

let
  isPy3k = majorVersion == "3";
  passthru = passthruFun {
    inherit self sourceVersion pythonVersion packageOverrides;
    implementation = "pypy";
    libPrefix = "pypy${pythonVersion}";
    executable = "pypy${lib.optionalString isPy3k "3"}";
    sitePackages = "site-packages";
    hasDistutilsCxxPatch = false;

    # Not possible to cross-compile with.
    pythonOnBuildForBuild = throw "${pname} does not support cross compilation";
    pythonOnBuildForHost = self;
    pythonOnBuildForTarget = throw "${pname} does not support cross compilation";
    pythonOnHostForHost = throw "${pname} does not support cross compilation";
    pythonOnTargetForTarget = throw "${pname} does not support cross compilation";
  };
  pname = "${passthru.executable}_prebuilt";
  version = with sourceVersion; "${major}.${minor}.${patch}";

  majorVersion = lib.versions.major pythonVersion;

  downloadUrls = {
    aarch64-linux = "https://downloads.python.org/pypy/pypy${pythonVersion}-v${version}-aarch64.tar.bz2";
    x86_64-linux = "https://downloads.python.org/pypy/pypy${pythonVersion}-v${version}-linux64.tar.bz2";
    aarch64-darwin = "https://downloads.python.org/pypy/pypy${pythonVersion}-v${version}-macos_arm64.tar.bz2";
    x86_64-darwin = "https://downloads.python.org/pypy/pypy${pythonVersion}-v${version}-macos_x86_64.tar.bz2";
  };

in with passthru; stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = downloadUrls.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");
    inherit hash;
  };

  buildInputs = [
    bzip2
    expat
    gdbm
    ncurses6
    sqlite
    zlib
    stdenv.cc.cc.libgcc or null
  ] ++ lib.optionals stdenv.isLinux [
    tcl-8_5
    tk-8_5
  ] ++ lib.optionals stdenv.isDarwin [
    tcl-8_6
    tk-8_6
  ];

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    echo "Moving files to $out"
    mv -t $out bin include lib-python lib_pypy site-packages
    mv $out/bin/libpypy*-c${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/
    ${lib.optionalString stdenv.isLinux ''
      mv lib/libffi.so.6* $out/lib/
      rm $out/bin/*.debug
    ''}

    echo "Removing bytecode"
    find . -name "__pycache__" -type d -depth -delete

    # Include a sitecustomize.py file
    cp ${../sitecustomize.py} $out/${sitePackages}/sitecustomize.py

    runHook postInstall
  '';

  preFixup = lib.optionalString (stdenv.isLinux) ''
    find $out/{lib,lib_pypy*} -name "*.so" \
      -exec patchelf \
        --replace-needed libtinfow.so.6 libncursesw.so.6 \
        --replace-needed libgdbm.so.4 libgdbm_compat.so.4 {} \;
  '' + lib.optionalString (stdenv.isDarwin) ''
    install_name_tool \
      -change \
        @rpath/lib${executable}-c.dylib \
        $out/lib/lib${executable}-c.dylib \
        $out/bin/${executable}
    install_name_tool \
      -change \
        /opt/homebrew${lib.optionalString stdenv.isx86_64 "_x86_64"}/opt/tcl-tk/lib/libtcl8.6.dylib \
        ${tcl-8_6}/lib/libtcl8.6.dylib \
        $out/lib_pypy/_tkinter/*.so
    install_name_tool \
      -change \
        /opt/homebrew${lib.optionalString stdenv.isx86_64 "_x86_64"}/opt/tcl-tk/lib/libtk8.6.dylib \
        ${tk-8_6}/lib/libtk8.6.dylib \
        $out/lib_pypy/_tkinter/*.so
  '';

  doInstallCheck = true;

  # Check whether importing of (extension) modules functions
  installCheckPhase = let
    modules = [
      "ssl"
      "sys"
      "curses"
    ] ++ lib.optionals (!isPy3k) [
      "Tkinter"
    ] ++ lib.optionals isPy3k [
      "tkinter"
    ];
    imports = lib.concatMapStringsSep "; " (x: "import ${x}") modules;
  in ''
    echo "Testing whether we can import modules"
    $out/bin/${executable} -c '${imports}'
  '';

  setupHook = python-setup-hook sitePackages;

  donPatchElf = true;
  dontStrip = true;

  inherit passthru;

  meta = with lib; {
    homepage = "http://pypy.org/";
    description = "Fast, compliant alternative implementation of the Python language (${pythonVersion})";
    license = licenses.mit;
    platforms = lib.mapAttrsToList (arch: _: arch) downloadUrls;
  };

}
