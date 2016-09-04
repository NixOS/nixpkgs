{ lib, stdenv, fetchurl }:

let

  common = { pname, sha256 }: stdenv.mkDerivation rec {
    name = "${pname}-1.79.1";

    src = fetchurl {
      url = "mirror://sourceforge/docbook/${name}.tar.bz2";
      inherit sha256;
    };

    dontBuild = true;

    installPhase = ''
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
    sha256 = "0s59lihif2fr7rznckxr2kfyrvkirv76r1zvidp9b5mj28p4apvj";
  };

  docbook_xsl_ns = common {
    pname = "docbook-xsl-ns";
    sha256 = "170ggf5dgjar65kkn5n33kvjr3pdinpj66nnxfx8b2avw0k91jin";
  };

}
