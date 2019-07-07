{ lib, stdenv, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "docbook5-5.0";

  src = fetchurl {
    url = http://www.docbook.org/xml/5.0/docbook-5.0.zip;
    sha256 = "13i04dkd709f0p5f2413sf2y9321pfi4y85ynf8wih6ryphnbk9x";
  };

  nativeBuildInputs = [ unzip ];

  installPhase =
    ''
      dst=$out/share/xml/docbook-5.0
      mkdir -p $dst
      cp -prv * $dst/

      substituteInPlace $dst/catalog.xml --replace 'uri="' "uri=\"$dst/"

      rm -rf $dst/docs $dst/ChangeLog

      # Backwards compatibility. Will remove eventually.
      mkdir -p $out/xml/rng $out/xml/dtd
      ln -s $dst/rng $out/xml/rng/docbook
      ln -s $dst/dtd $out/xml/dtd/docbook
    '';

  meta = {
    description = "Schemas for DocBook 5.0, a semantic markup language for technical documentation";
    homepage = https://docbook.org/xml/5.0/;
    maintainers = [ lib.maintainers.eelco ];
    platforms = lib.platforms.all;
  };
}
