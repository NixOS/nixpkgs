{stdenv, fetchurl, unzip}:

assert unzip != null;

stdenv.mkDerivation {
  name = "docbook-xml-ebnf-1.2b1";
  builder = ./builder.sh;
  dtd = fetchurl {
    url = http://www.docbook.org/xml/ebnf/1.2b1/dbebnf.dtd;
    sha256 = "0min5dsc53my13b94g2yd65q1nkjcf4x1dak00bsc4ckf86mrx95";
  };
  catalog = ./docbook-ebnf.cat;

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
