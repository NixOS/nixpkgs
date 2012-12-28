{ stdenv
, fetchurl
, aterm
, ptSupport
, pkgconfig
}:
let 
  isMingw = stdenv ? cross && stdenv.cross.config == "i686-pc-mingw32" ;
in
stdenv.mkDerivation rec {
  name = "ptable-support-1.2";

  src = fetchurl {
    url = "http://www.meta-environment.org/releases/${name}.tar.gz";
    sha256 = "0bqx1xsimf9vq6q2qnsy3565rzlha4cm2blcn3kqwbirfyj1kln9";
  };

  buildInputs = [aterm ptSupport];
  nativeBuildInputs = [pkgconfig];
  
  dontStrip = isMingw;
} 
