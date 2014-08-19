{ stdenv, fetchurl, python }:

stdenv.mkDerivation {
  name = "clearsilver-0.10.3";

  src = fetchurl {
    url = http://www.clearsilver.net/downloads/clearsilver-0.10.3.tar.gz;
    md5 = "ff4104b0e58bca1b61d528edbd902769";
  };

  builder = ./builder.sh;

  inherit stdenv python;

  meta = {
    description = "Fast, powerful, and language-neutral HTML template system";
    homepage = http://www.clearsilver.net/;
  };
}
