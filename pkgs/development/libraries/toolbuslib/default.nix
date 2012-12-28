{ stdenv
, fetchurl
, aterm
, pkgconfig
, w32api
}:
let 
  isMingw = stdenv ? cross && stdenv.cross.config == "i686-pc-mingw32" ;
in
stdenv.mkDerivation rec {
  name = "toolbuslib-1.1";

  src = fetchurl {
    url = "http://www.meta-environment.org/releases/${name}.tar.gz";
    sha256 = "0f4q0r177lih23ypypc8ckkyv5vhvnkhbrv25gswrqdif5dxbwr0";
  };

  patches = if isMingw then [./mingw.patch] else [];
  
  buildInputs = [aterm] ++ (if isMingw then [w32api] else []);
  nativeBuildInputs = [pkgconfig];
  
  dontStrip = isMingw; 
}  
