{stdenv, fetchurl, unzip}:

assert unzip != null;

stdenv.mkDerivation {
  name = "docbook-xml-ebnf-1.2b1";
  builder = ./builder.sh;
  dtd = fetchurl {
    url = http://www.docbook.org/xml/ebnf/1.2b1/dbebnf.dtd;
    md5 = "e50f7d38caf4285965c7a247e026fa7c";
  };
  catalog = ./docbook-ebnf.cat;

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
