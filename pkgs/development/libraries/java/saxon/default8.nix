{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "saxonb-8.0";
  builder = ./unzip-builder.sh;
  src = fetchurl {
    url = http://belnet.dl.sourceforge.net/sourceforge/saxon/saxonb8-0.zip;
    md5 = "d05fbd398847ef27b2d1d875bb5136ea";
  };

  inherit unzip;
  buildInputs = [unzip];
}
