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
, zlib
# For the Python package set
, packageOverrides ? (self: super: {})
, sourceVersion
, pythonVersion
, sha256
, passthruFun
}:

# This version of PyPy is primarily added to speed-up translation of
# our PyPy source build when developing that expression.

with lib;

let
  isPy3k = majorVersion == "3";
  passthru = passthruFun {
    inherit self sourceVersion pythonVersion packageOverrides;
    implementation = "pypy";
    libPrefix = "pypy${pythonVersion}";
    executable = "pypy${if isPy3k then "3" else ""}";
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
    inherit sha256;
  };

  buildInputs = [
    bzip2
    expat
    gdbm
    ncurses6
    sqlite
    tcl-8_5
    tk-8_5
    zlib
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
  '';

  # Native libraries are not working in darwin
  doInstallCheck = !stdenv.isDarwin;

  # Check whether importing of (extension) modules functions
  installCheckPhase = let
    modules = [
      "ssl"
      "sys"
      "curses"
    ] ++ optionals (!isPy3k) [
      "Tkinter"
    ] ++ optionals isPy3k [
      "tkinter"
    ];
    imports = concatMapStringsSep "; " (x: "import ${x}") modules;
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
