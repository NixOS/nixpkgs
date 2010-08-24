{ stdenv
, fetchurl
, aterm
, toolbuslib
, errorSupport
, pkgconfig
}:
let 
  isMingw = stdenv ? cross && stdenv.cross.config == "i686-pc-mingw32" ;
in
stdenv.mkDerivation ( rec {
  name = "pt-support-2.4";

  src = fetchurl {
    url = "http://www.meta-environment.org/releases/${name}.tar.gz";
    sha256 = "14krhhhmrg7605ppglzd1k08n7x61g7vdkh11qcz8hb9r4n71j45";
  };

  buildInputs = [aterm toolbuslib errorSupport];
  buildNativeInputs = [pkgconfig];
  
  dontStrip = isMingw;
} // ( if isMingw then { NIX_CFLAGS_COMPILE = "-O2 -Wl,--stack=0x2300000"; } else {} ) )

