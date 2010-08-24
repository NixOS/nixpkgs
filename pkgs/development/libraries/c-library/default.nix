{ stdenv
, fetchurl
, aterm
, pkgconfig
}:
let 
  isMingw = stdenv ? cross && stdenv.cross.config == "i686-pc-mingw32" ;
in
stdenv.mkDerivation rec {
  name = "c-library-1.2";

  src = fetchurl {
    url = "http://www.meta-environment.org/releases/${name}.tar.gz";
    sha256 = "0rmhag2653nq76n1n49blii9zx0ph58szv1xzw1i551wmw7yrz88";
  };
  
  patches = if isMingw then [./mingw.patch] else [];
  
  buildInputs = [aterm];
  buildNativeInputs = [pkgconfig];
  dontStrip = isMingw;
}  
