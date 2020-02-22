{ stdenv, fetchurl
, exampleSupport ? false # Example encoding program
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "fdk-aac";
  version = "2.0.1";

  src = fetchurl {
    url = "mirror://sourceforge/opencore-amr/fdk-aac/${pname}-${version}.tar.gz";
    sha256 = "0wgjjc0dfkm2w966lc9c8ir8f671vl1ppch3mya3h58jjjm360c4";
  };

  configureFlags = [ ]
    ++ optional exampleSupport "--enable-example";

  meta = {
    description = "A high-quality implementation of the AAC codec from Android";
    homepage    = https://sourceforge.net/projects/opencore-amr/;
    license     = licenses.asl20;
    maintainers = with maintainers; [ codyopel ];
    platforms   = platforms.all;
  };
}
