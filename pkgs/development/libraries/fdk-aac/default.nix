{ stdenv, fetchurl
, exampleSupport ? false # Example encoding program
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "fdk-aac-${version}";
  version = "0.1.6";

  src = fetchurl {
    url = "mirror://sourceforge/opencore-amr/fdk-aac/${name}.tar.gz";
    sha256 = "1bfkpqba0v2jgxqwaf9xsrr63a089wckrir497lm6nbbmi11pdma";
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
