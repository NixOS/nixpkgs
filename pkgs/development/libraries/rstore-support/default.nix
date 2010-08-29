
{ stdenv
, fetchurl
, aterm
, toolbuslib
, pkgconfig
}:
let 
  isMingw = stdenv ? cross && stdenv.cross.config == "i686-pc-mingw32" ;
in    
stdenv.mkDerivation rec {
  name = "rstore-support-1.0";

  src = fetchurl {
    url = "http://www.meta-environment.org/releases/${name}.tar.gz";
    sha256 = "0fahq947bdaiymfz08fb2kvbnggpc8ybhh3sbxgja61pp2jizg46";
  };

  buildInputs = [aterm toolbuslib];
  buildNativeInputs = [pkgconfig];  

  dontStrip = isMingw;
} 
