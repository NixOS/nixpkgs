{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "docbook5-5.0";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://www.docbook.org/xml/5.0/docbook-5.0.zip;
    sha256 = "13i04dkd709f0p5f2413sf2y9321pfi4y85ynf8wih6ryphnbk9x";
  };

  buildInputs = [unzip];
}
