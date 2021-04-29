{ lib, stdenv, fetchurl
, exampleSupport ? false # Example encoding program
}:

with lib;
stdenv.mkDerivation rec {
  pname = "fdk-aac";
  version = "2.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/opencore-amr/fdk-aac/${pname}-${version}.tar.gz";
    sha256 = "sha256-yehjDPnUM/POrXSQahUg0iI/ibzT+pJUhhAXRAuOsi8=";
  };

  configureFlags = [ ]
    ++ optional exampleSupport "--enable-example";

  meta = {
    description = "A high-quality implementation of the AAC codec from Android";
    homepage    = "https://sourceforge.net/projects/opencore-amr/";
    license     = licenses.asl20;
    maintainers = with maintainers; [ codyopel ];
    platforms   = platforms.all;
  };
}
