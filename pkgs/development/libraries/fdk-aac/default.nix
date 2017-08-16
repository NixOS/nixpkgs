{ stdenv, fetchurl
, exampleSupport ? false # Example encoding program
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "fdk-aac-${version}";
  version = "0.1.5";

  src = fetchurl {
    url = "mirror://sourceforge/opencore-amr/fdk-aac/${name}.tar.gz";
    sha256 = "1msdkcf559agmpycd4bk0scm2s2h9jyzbnnw1yrfarxlcwm5jr11";
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
