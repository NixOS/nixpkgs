{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "gettext-0.12.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/gettext/gettext-0.12.1.tar.gz;
    md5 = "5d4bddd300072315e668247e5b7d5bdb";
  };
}
