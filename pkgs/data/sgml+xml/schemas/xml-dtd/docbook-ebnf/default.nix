{stdenv, fetchurl, unzip}:

assert unzip != null;

stdenv.mkDerivation {
  name = "docbook-xml-ebnf-1.2b1";
  builder = ./builder.sh;
  dtd = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/dbebnf-1.2b1.dtd;
    md5 = "e50f7d38caf4285965c7a247e026fa7c";
  };
  catalog = ./docbook-ebnf.cat;
}
