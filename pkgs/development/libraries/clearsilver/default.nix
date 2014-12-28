{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "clearsilver-0.10.5";

  src = fetchurl {
    url = "http://www.clearsilver.net/downloads/${name}.tar.gz";
    sha256 = "1046m1dpq3nkgxbis2dr2x7hynmy51n64465q78d7pdgvqwa178y";
  };

  builder = ./builder.sh;

  inherit stdenv python;

  meta = {
    description = "Fast, powerful, and language-neutral HTML template system";
    homepage = http://www.clearsilver.net/;
  };
}
