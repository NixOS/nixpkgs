{ stdenv, fetchsvn, python, scons, makeWrapper }:

let
  system = stdenv.system;
  arch = if system == "i686-linux" then "ia32" else if system == "x86_64-linux" then "x64" else ""; 
in
assert system == "i686-linux" || system == "x86_64-linux";
stdenv.mkDerivation rec {
    name = "v8-r${toString src.rev}";
    src = fetchsvn {
      url = http://v8.googlecode.com/svn/trunk ;
      sha256 = "1p51zh1l9c2gq3g4qk713n6qki9by3llx4p46inncvqfrimgshxb";
      rev = 5865;
    };
    
    buildInputs = [python scons makeWrapper];
    
    buildPhase = ''
      export CXX=`type -p g++`
      scons snapshot=on importenv=PATH arch=${arch}
      scons snapshot=on library=shared importenv=PATH arch=${arch}
      scons sample=shell snapshot=on importenv=PATH arch=${arch} 
    '';
    
    installPhase = ''
      ensureDir $out/bin
      ensureDir $out/lib
      
      cp -v libv8.* $out/lib
      cp -v shell $out/bin/v8-shell
      cp -vR include $out/
      wrapProgram $out/bin/v8-shell --set LD_LIBRARY_PATH $out/lib  
     
    '';
}
