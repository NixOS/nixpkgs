{ lib
, stdenv
, fetchurl
, python-setup-hook
, self
, which
# Dependencies
, bzip2
, zlib
, openssl_1_0_2
, expat
, ncurses6
, tcl-8_5
, tk-8_5
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

  majorVersion = substring 0 1 pythonVersion;

  deps = [
    bzip2
    zlib
    openssl_1_0_2
    expat
    ncurses6
    tcl-8_5
    tk-8_5
  ];

in with passthru; stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://downloads.python.org/pypy/pypy${pythonVersion}-v${version}-linux64.tar.bz2";
    inherit sha256;
  };

  buildInputs = [ which ];

  installPhase = ''
    mkdir -p $out/lib
    echo "Moving files to $out"
    mv -t $out bin include lib-python lib_pypy site-packages
    mv lib/libffi.so.6* $out/lib/

    mv $out/bin/libpypy*-c.so $out/lib/

    rm $out/bin/*.debug

    echo "Patching binaries"
    interpreter=$(patchelf --print-interpreter $(readlink -f $(which patchelf)))
    patchelf --set-interpreter $interpreter \
             --set-rpath $out/lib \
             $out/bin/pypy*

    pushd $out
    find {lib,lib_pypy*} -name "*.so" -exec patchelf --remove-needed libncursesw.so.6 --replace-needed libtinfow.so.6 libncursesw.so.6 {} \;
    find {lib,lib_pypy*} -name "*.so" -exec patchelf --set-rpath ${lib.makeLibraryPath deps}:$out/lib {} \;

    echo "Removing bytecode"
    find . -name "__pycache__" -type d -depth -exec rm -rf {} \;
    popd

    # Include a sitecustomize.py file
    cp ${../sitecustomize.py} $out/${sitePackages}/sitecustomize.py

  '';

  doInstallCheck = true;

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
    platforms = [ "x86_64-linux" ];
  };

}
