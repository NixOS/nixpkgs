
{ stdenv
, fetchurl
, aterm
, toolbuslib
, errorSupport
, ptSupport
, pkgconfig
}:
let 
  isMingw = stdenv ? cross && stdenv.cross.config == "i686-pc-mingw32" ;
in
stdenv.mkDerivation rec {
  name = "sdf-support-2.5";

  src = fetchurl {
    url = "http://www.meta-environment.org/releases/${name}.tar.gz";
    sha256 = "0zazks2yvm8gqdx0389b1b8hf8ss284q1ywk4d7cqc8glba29cs0";
  };

  patches = if isMingw then [./mingw.patch] else [];

  buildInputs = [aterm toolbuslib errorSupport ptSupport];
  buildNativeInputs = [pkgconfig];  

  dontStrip = isMingw;
} 
