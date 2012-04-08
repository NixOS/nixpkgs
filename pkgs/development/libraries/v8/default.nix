{ stdenv, fetchsvn, python, scons, readline, makeWrapper }:

assert readline != null;

let
  system = stdenv.system;
  arch = if system == "i686-linux" then "ia32" else if system == "x86_64-linux" || system == "x86_64-darwin" then "x64" else "";
  version = "3.6.6.24";
in
assert arch != "";
stdenv.mkDerivation rec {
    name = "v8-${version}";
    src = fetchsvn {
      url = "http://v8.googlecode.com/svn/tags/${version}";
      sha256 = "405c905f6240b37b0da14769781e7ec6444fe9153a02ddacd5d774713fe1eb41";
    };

    buildInputs = [python scons readline makeWrapper];

    buildPhase = ''
      export CXX=`type -p g++`
      export CPPPATH=${readline}/include
      export LIBPATH=${readline}/lib
      scons snapshot=on console=readline library=shared importenv=PATH arch=${arch} library d8
    '';

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/lib

      cp -v libv8.* $out/lib
      cp -v d8 $out/bin/d8
      cp -vR include $out/
      wrapProgram $out/bin/d8 --set ${if stdenv.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH"} $out/lib
    '';
}
