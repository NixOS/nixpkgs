{ stdenv, fetchurl
, exampleSupport ? false # Example encoding program
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "fdk-aac-${version}";
  version = "2.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/opencore-amr/fdk-aac/${name}.tar.gz";
    sha256 = "0v6rbyw9f9lpfvcg3v1qyapga5hqfnb3wp3x5yaxpwcgjw7ydmpp";
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
