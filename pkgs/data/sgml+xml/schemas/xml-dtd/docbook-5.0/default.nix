{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "docbook-5.0b6";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://docbook.org/xml/5.0b6/docbook-5.0b6.tar.gz;
    md5 = "4bf53ff6eb4721a14b37c97155379bd2";
  };
}
