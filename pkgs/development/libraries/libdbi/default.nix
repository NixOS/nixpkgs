{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libdbi-0.8.3";

  src = fetchurl {
    url = "mirror://sourceforge/libdbi/${name}.tar.gz";
    sha256 = "1qx5d5ikx65k73ir9rf557ri6j99ihsnjqqyznqsf7dvprb1ir3j";
  };

  configureFlags = "--disable-docs";

  meta = {
    description = "DB independent interface to DB";
  };
}
