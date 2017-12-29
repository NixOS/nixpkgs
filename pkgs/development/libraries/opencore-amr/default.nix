{ stdenv, fetchurl }:

let
    version = "0.1.5";
in 
stdenv.mkDerivation {
  name = "opencore-amr-${version}";
  src = fetchurl {
    url = "https://vorboss.dl.sourceforge.net/project/opencore-amr/opencore-amr/opencore-amr-${version}.tar.gz";
    sha256 = "0hfk9khz3by0119h3jdwgdfd7jgkdbzxnmh1wssvylgnsnwnq01c";
  };
  
  meta = {
    homepage = https://opencore-amr.sourceforge.io/;
    description = "Library of OpenCORE Framework implementation of Adaptive Multi Rate Narrowband and Wideband (AMR-NB and AMR-WB) speech codec. 
    Library of VisualOn implementation of Adaptive Multi Rate Wideband (AMR-WB)";
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.kiloreux ];
  };
}
