{lib, stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "docbook-xml-ebnf-1.2b1";

  dtd = fetchurl {
    url = "http://www.docbook.org/xml/ebnf/1.2b1/dbebnf.dtd";
    sha256 = "0min5dsc53my13b94g2yd65q1nkjcf4x1dak00bsc4ckf86mrx95";
  };
  catalog = ./docbook-ebnf.cat;

  unpackPhase = ''
    mkdir -p $out/xml/dtd/docbook-ebnf
    cd $out/xml/dtd/docbook-ebnf
  '';

  installPhase = ''
    cp -p $dtd dbebnf.dtd
    cp -p $catalog $(stripHash $catalog)
  '';

  meta = {
    platforms = lib.platforms.unix;
  };
}
