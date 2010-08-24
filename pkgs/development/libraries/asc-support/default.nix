
{ stdenv
, fetchurl
, aterm
, toolbuslib
, asfSupport
, errorSupport
, ptSupport
, sglr
, tideSupport
, cLibrary
, configSupport 
, ptableSupport
, rstoreSupport
, pkgconfig
}:
let 
  isMingw = stdenv ? cross && stdenv.cross.config == "i686-pc-mingw32" ;
in
stdenv.mkDerivation rec {
  name = "asc-support-2.6";

  src = fetchurl {
    url = "http://www.meta-environment.org/releases/${name}.tar.gz";
    sha256 = "1svq368kdxnmjdfv8sqs0cn9s69c75qcp44mpapfjj6kfhrzkxdc";
  };
  
  patches = if isMingw then [./mingw.patch] else [];

  buildInputs = [aterm toolbuslib asfSupport errorSupport ptSupport sglr tideSupport cLibrary configSupport ptableSupport rstoreSupport ];
  buildNativeInputs = [pkgconfig];
  
  dontStrip = isMingw;
}  
