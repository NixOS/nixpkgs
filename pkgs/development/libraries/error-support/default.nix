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
  name = "error-support-1.6";

  src = fetchurl {
    url = "http://www.meta-environment.org/releases/${name}.tar.gz";
    sha256 = "0sdw3mrh90k76w2pvpdfg7d2cxfxb3s5spbqglkkpvx8bldhlk33";
  };

  buildInputs = [aterm toolbuslib];
  buildNativeInputs = [pkgconfig];

  dontStrip = isMingw;
} 
