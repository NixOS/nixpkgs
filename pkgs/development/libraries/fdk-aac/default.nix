{ stdenv, fetchurl
, exampleSupport ? false # Example encoding program
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "fdk-aac-${version}";
  version = "0.1.4";

  src = fetchurl {
    url = "mirror://sourceforge/opencore-amr/fdk-aac/${name}.tar.gz";
    sha256 = "1aqmzxri23q83wfmwbbashs27mq1mapvfirz5r9i7jkphrwgw42r";
  };

  configureFlags = [ ]
    ++ optional exampleSupport "--enable-example";

  meta = {
    description = "A high-quality implementation of the AAC codec from Android";
    homepage    = http://sourceforge.net/projects/opencore-amr/;
    license     = licenses.asl20;
    maintainers = with maintainers; [ codyopel ];
    platforms   = platforms.all;
  };
}
