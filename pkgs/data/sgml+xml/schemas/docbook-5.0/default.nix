{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "docbook5-5.0-pre-cr1";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://www.docbook.org/xml/5.0CR1/docbook-5.0CR1.tar.gz;
    sha256 = "15bbnydspiry7k7fwl2gdjb53nyw2vg6xwpn3d40f03mcf0bkw11";
  };
}
