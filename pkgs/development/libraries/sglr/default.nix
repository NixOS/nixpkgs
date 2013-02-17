
{ stdenv
, fetchurl
, aterm
, toolbuslib
, cLibrary
, configSupport
, ptSupport
, ptableSupport
, errorSupport 
, pkgconfig
}:
let 
  isMingw = stdenv ? cross && stdenv.cross.config == "i686-pc-mingw32" ;
in    
stdenv.mkDerivation rec {
  name = "sglr-4.5.3";

  src = fetchurl {
    url = "http://www.meta-environment.org/releases/${name}.tar.gz";
    sha256 = "1k3q9k32r6i2wh3k6b000fs11n0vhy6yr8kr0bd58ybwp5dnjj77";
  };

  buildInputs = [aterm toolbuslib cLibrary configSupport ptSupport ptableSupport errorSupport];
  nativeBuildInputs = [pkgconfig];  

  dontStrip = isMingw;
} 
