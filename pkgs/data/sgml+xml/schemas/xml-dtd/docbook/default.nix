{stdenv, fetchurl, unzip}:

assert unzip != null;

stdenv.mkDerivation {
  name = "docbook-xml-4.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.oasis-open.org/docbook/xml/4.2/docbook-xml-4.2.zip;
    md5 = "73fe50dfe74ca631c1602f558ed8961f";
  };
  unzip = unzip;
}
