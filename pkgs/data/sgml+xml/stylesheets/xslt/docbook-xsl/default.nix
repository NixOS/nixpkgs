{ lib, stdenv, substituteAll, fetchurl, fetchpatch, findXMLCatalogs, writeScriptBin, ruby, bash }:

let

  common = { pname, sha256, suffix ? "" }: let
    legacySuffix = if suffix == "-nons" then "" else "-ns";
    self = stdenv.mkDerivation rec {
      inherit pname;
      version = "1.79.2";

      src = fetchurl {
        url = "https://github.com/docbook/xslt10-stylesheets/releases/download/release%2F${version}/docbook-xsl${suffix}-${version}.tar.bz2";
        inherit sha256;
      };

      patches = [
        # Prevent a potential stack overflow
        # https://github.com/docbook/xslt10-stylesheets/pull/37
        (fetchpatch {
          url = https://src.fedoraproject.org/rpms/docbook-style-xsl/raw/e3ae7a97ed1d185594dd35954e1a02196afb205a/f/docbook-style-xsl-non-recursive-string-subst.patch;
          sha256 = "0lrjjg5kpwwmbhkxzz6i5zmimb6lsvrrdhzc2qgjmb3r6jnsmii3";
          stripLen = "1";
        })

        # Add legacy sourceforge.net URIs to the catalog
        (substituteAll {
          src = ./catalog-legacy-uris.patch;
          inherit legacySuffix suffix version;
        })
      ];

      propagatedBuildInputs = [ findXMLCatalogs ];

      dontBuild = true;

      installPhase = ''
        dst=$out/share/xml/${pname}
        mkdir -p $dst
        rm -rf RELEASE* README* INSTALL TODO NEWS* BUGS install.sh tools Makefile tests extensions webhelp
        mv * $dst/

        # Backwards compatibility. Will remove eventually.
        mkdir -p $out/xml/xsl
        ln -s $dst $out/xml/xsl/docbook

        # More backwards compatibility
        ln -s $dst $out/share/xml/docbook-xsl${legacySuffix}
      '';

      passthru.dbtoepub = writeScriptBin "dbtoepub"
        ''
          #!${bash}/bin/bash
          exec -a dbtoepub ${ruby}/bin/ruby ${self}/share/xml/${pname}/epub/bin/dbtoepub "$@"
        '';

      meta = {
        homepage = http://wiki.docbook.org/topic/DocBookXslStylesheets;
        description = "XSL stylesheets for transforming DocBook documents into HTML and various other formats";
        maintainers = [ lib.maintainers.eelco ];
        platforms = lib.platforms.all;
      };
    };
  in self;

in {

  docbook-xsl-nons = common {
    pname = "docbook-xsl-nons";
    suffix = "-nons";
    sha256 = "00i1hdyxim8jymv2dz68ix3wbs5w6isxm8ijb03qk3vs1g59x2zf";
  };

  docbook-xsl-ns = common {
    pname = "docbook-xsl-ns";
    sha256 = "0wd33z41kdsybyx3ay21w6bdlmgpd9kyn3mr5y520lsf8km28r9i";
  };
}
