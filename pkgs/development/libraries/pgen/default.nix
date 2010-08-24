
{ stdenv
, fetchurl
, aterm
, toolbuslib
, cLibrary
, configSupport
, ptSupport
, ptableSupport
, errorSupport 
, tideSupport
, ascSupport
, asfSupport
, sdfSupport
, sglr
, pkgconfig
}:
let 
  isMingw = stdenv ? cross && stdenv.cross.config == "i686-pc-mingw32" ;
in
stdenv.mkDerivation ( rec {
  name = "pgen-2.8.1";

  src = fetchurl {
    url = "http://www.meta-environment.org/releases/${name}.tar.gz";
    sha256 = "0z5x6rnsp732jdszcgm22bfw3v6ai9zl49b3s5iyk9qjfmyx0h41";
  };

  buildInputs = [aterm toolbuslib cLibrary configSupport ptSupport ptableSupport errorSupport tideSupport sdfSupport sglr ascSupport asfSupport];
  buildNativeInputs = [pkgconfig];

  dontStrip = isMingw;
} // ( if isMingw then { NIX_CFLAGS_COMPILE = "-O2 -Wl,--stack=0x2300000"; } else {} ) )
