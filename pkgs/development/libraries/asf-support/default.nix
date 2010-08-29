
{ stdenv
, fetchurl
, aterm
, errorSupport
, ptSupport
, pkgconfig
}:
let 
  isMingw = stdenv ? cross && stdenv.cross.config == "i686-pc-mingw32" ;
in
stdenv.mkDerivation rec {
  name = "asf-support-1.8";

  src = fetchurl {
    url = "http://www.meta-environment.org/releases/${name}.tar.gz";
    sha256 = "04f7grfadq0si24rs9vlcknlahfa7nb3d6n6pjl1qbxi8m1gwhnc";
  };

  buildInputs = [aterm errorSupport ptSupport];
  buildNativeInputs = [pkgconfig];  

  dontStrip = isMingw;
} 
