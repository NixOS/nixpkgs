
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
  name = "tide-support-1.3.1";

  src = fetchurl {
    url = "http://www.meta-environment.org/releases/${name}.tar.gz";
    sha256 = "06n80rihcj2dhrvx8969jbgxqvg2vb3jqpkdmcr47y08xs7j5n2b";
  };

  buildInputs = [aterm toolbuslib];
  buildNativeInputs = [pkgconfig];    

  dontStrip = isMingw;
} 
