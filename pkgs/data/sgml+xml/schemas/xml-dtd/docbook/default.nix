{stdenv, fetchurl, unzip}:

assert !isNull unzip;

derivation {
  name = "docbook-xml-4.2";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.oasis-open.org/docbook/xml/4.2/docbook-xml-4.2.zip;
    md5 = "73fe50dfe74ca631c1602f558ed8961f";
  };
  stdenv = stdenv;
  unzip = unzip;
}
