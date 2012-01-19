{ stdenv, fetchsvn, python, scons, readline, makeWrapper }:

assert readline != null;

let
  system = stdenv.system;
  arch = if system == "i686-linux" then "ia32" else if system == "x86_64-linux" then "x64" else "";
  version = "3.6.6.17";
in
assert system == "i686-linux" || system == "x86_64-linux";
stdenv.mkDerivation rec {
    name = "v8-${version}";
    src = fetchsvn {
      url = "http://v8.googlecode.com/svn/tags/${version}";
      sha256 = "7080d53b9d3aefc591c2e181dcf97d538ce36177284fc658eca6420ea36a926f";
    };

    buildInputs = [python scons readline makeWrapper];

    buildPhase = ''
      export CXX=`type -p g++`
      export CPPPATH=${readline}/include
      export LIBPATH=${readline}/lib
      scons snapshot=on console=readline library=shared importenv=PATH arch=${arch} library d8
    '';

    installPhase = ''
      ensureDir $out/bin
      ensureDir $out/lib

      cp -v libv8.* $out/lib
      cp -v d8 $out/bin/d8
      cp -vR include $out/
      wrapProgram $out/bin/d8 --set LD_LIBRARY_PATH $out/lib
    '';
}
