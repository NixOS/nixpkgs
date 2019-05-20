{ stdenv
, fetchurl
, python-setup-hook
, self
, which
# Dependencies
, bzip2
, zlib
, openssl
, expat
, libffi
, ncurses
, tcl
, tk
# For the Python package set
, packageOverrides ? (self: super: {})
, sourceVersion
, pythonVersion
, sha256
, passthruFun
}:

# This version of PyPy is primarily added to speed-up translation of
# our PyPy source build when developing that expression.

with stdenv.lib;

let
  isPy3k = majorVersion == "3";
  passthru = passthruFun rec {
    inherit self sourceVersion pythonVersion packageOverrides;
    implementation = "pypy";
    libPrefix = "pypy${pythonVersion}";
    executable = "pypy${if isPy3k then "3" else ""}";
    pythonForBuild = self; # Not possible to cross-compile with.
    sitePackages = "site-packages";
    hasDistutilsCxxPatch = false;
  };
  pname = "${passthru.executable}_prebuilt";
  version = with sourceVersion; "${major}.${minor}.${patch}";

  majorVersion = substring 0 1 pythonVersion;

  setupHook = python-setup-hook sitePackages;

  deps = [
    bzip2
    zlib
    openssl
    expat
    libffi
    ncurses
    tcl
    tk
  ];

in with passthru; stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url= "https://bitbucket.org/pypy/pypy/downloads/pypy${majorVersion}-v${version}-linux64.tar.bz2";
    inherit sha256;
  };

  buildInputs = [ which ];

  installPhase = ''
    mkdir -p $out/lib
    echo "Moving files to $out"
    mv -t $out bin include lib-python lib_pypy site-packages

    mv $out/bin/libpypy*-c.so $out/lib/

    rm $out/bin/*.debug

    echo "Patching binaries"
    interpreter=$(patchelf --print-interpreter $(readlink -f $(which patchelf)))
    patchelf --set-interpreter $interpreter \
             --set-rpath $out/lib \
             $out/bin/pypy*

    pushd $out
    find {lib,lib_pypy*} -name "*.so" -exec patchelf --replace-needed "libbz2.so.1.0" "libbz2.so.1" {} \;
    find {lib,lib_pypy*} -name "*.so" -exec patchelf --set-rpath ${stdenv.lib.makeLibraryPath deps} {} \;

    echo "Removing bytecode"
    find . -name "__pycache__" -type d -depth -exec rm -rf {} \;
    popd
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

  meta = with stdenv.lib; {
    homepage = http://pypy.org/;
    description = "Fast, compliant alternative implementation of the Python language (${pythonVersion})";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
  };

}