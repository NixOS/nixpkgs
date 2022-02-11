{ lib, stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "docbook5";
  version = "5.0.1";

  src = fetchurl {
    url = "http://www.docbook.org/xml/${version}/docbook-${version}.zip";
    sha256 = "1iz3hq1lqgnshvlz4j9gvh4jy1ml74qf90vqf2ikbq0h4i2xzybs";
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
    homepage = "https://docbook.org/xml/5.0/";
    maintainers = [ lib.maintainers.eelco ];
    platforms = lib.platforms.all;
  };
}
