
{ stdenv
, fetchurl
, aterm
, pkgconfig
}:
let 
  isMingw = stdenv ? cross && stdenv.cross.config == "i686-pc-mingw32" ;
in
stdenv.mkDerivation rec {
  name = "config-support-1.4";

  src = fetchurl {
    url = "http://www.meta-environment.org/releases/${name}.tar.gz";
    sha256 = "0klhc7v760aklsy73pwn87snhgalkfxisac8srn8qcd3ljbfdrmi";
  };

  buildInputs = [aterm];
  buildNativeInputs = [pkgconfig];

  dontStrip = isMingw;
} 
