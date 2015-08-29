{ lib, stdenv, fetchurl }:

let

  common = { pname, sha256 }: stdenv.mkDerivation rec {
    name = "${pname}-1.78.1";

    src = fetchurl {
      url = "mirror://sourceforge/docbook/${name}.tar.bz2";
      inherit sha256;
    };

    buildPhase = "true";

    installPhase =
      ''
        dst=$out/share/xml/${pname}
        mkdir -p $dst
        rm -rf RELEASE* README* INSTALL TODO NEWS* BUGS install.sh svn* tools log Makefile tests extensions webhelp
        mv * $dst/

        # Backwards compatibility. Will remove eventually.
        mkdir -p $out/xml/xsl
        ln -s $dst $out/xml/xsl/docbook
      '';

    meta = {
      homepage = http://wiki.docbook.org/topic/DocBookXslStylesheets;
      description = "XSL stylesheets for transforming DocBook documents into HTML and various other formats";
      maintainers = [ lib.maintainers.eelco ];
      platforms = lib.platforms.all;
    };
  };

in {

  docbook_xsl = common {
    pname = "docbook-xsl";
    sha256 = "0rxl013ncmz1n6ymk2idvx3hix9pdabk8xn01cpcv32wmfb753y9";
  };

  docbook_xsl_ns = common {
    pname = "docbook-xsl-ns";
    sha256 = "1x3sc0axk9z3i6n0jhlsmzlmb723a4sjgslm9g12by6phirdx3ng";
  };

}
