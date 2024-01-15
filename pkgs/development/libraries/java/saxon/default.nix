{ lib, stdenv, fetchurl, unzip, jre, jre8 }:

let
  common = { pname, version, src, description, java ? jre
           , prog ? null, jar ? null, license ? lib.licenses.mpl20 }:
    stdenv.mkDerivation {
      name = "${pname}-${version}";
      inherit pname version src;

      nativeBuildInputs = [ unzip ];

      buildCommand = let
        prog' = if prog == null then pname else prog;
        jar' = if jar == null then pname else jar;
      in ''
        unzip $src -d $out
        mkdir -p $out/bin $out/share $out/share/java
        cp -s "$out"/*.jar "$out/share/java/"  # */
        rm -rf $out/notices
        mv $out/doc $out/share
        cat > $out/bin/${prog'} <<EOF
        #! $shell
        export JAVA_HOME=${jre}
        exec ${jre}/bin/java -jar $out/${jar'}.jar "\$@"
        EOF
        chmod a+x $out/bin/${prog'}
      '';

      meta = with lib; {
        inherit description license;
        homepage = "https://saxon.sourceforge.net/";
        sourceProvenance = with sourceTypes; [ binaryBytecode ];
        maintainers = with maintainers; [ rvl ];
        platforms = platforms.all;
      };
    };

in {
  saxon = common {
    pname = "saxon";
    version = "6.5.3";
    src = fetchurl {
      url = "mirror://sourceforge/saxon/saxon6_5_3.zip";
      sha256 = "0l5y3y2z4wqgh80f26dwwxwncs8v3nkz3nidv14z024lmk730vs3";
    };
    description = "XSLT 1.0 processor";
    # https://saxon.sourceforge.net/saxon6.5.3/conditions.html
    license = lib.licenses.mpl10;
    java = jre8;
  };

  saxonb_8_8 = common {
    pname = "saxonb";
    version = "8.8";
    jar = "saxon8";
    src = fetchurl {
      url = "mirror://sourceforge/saxon/saxonb8-8j.zip";
      sha256 = "15bzrfyd2f1045rsp9dp4znyhmizh1pm97q8ji2bc0b43q23xsb8";
    };
    description = "Complete and conformant processor of XSLT 2.0, XQuery 1.0, and XPath 2.0";
    java = jre8;
  };

  saxonb_9_1 = common {
    pname = "saxonb";
    version = "9.1.0.8";
    jar = "saxon9";
    src = fetchurl {
      url = "mirror://sourceforge/saxon/Saxon-B/9.1.0.8/saxonb9-1-0-8j.zip";
      sha256 = "1d39jdnwr3v3pzswm81zry6yikqlqy9dp2l2wmpqdiw00r5drg4j";
    };
    description = "Complete and conformant processor of XSLT 2.0, XQuery 1.0, and XPath 2.0";
  };

  saxon_9-he = common {
    pname = "saxon-he";
    version = "9.9.0.1";
    prog = "saxon-he";
    jar = "saxon9he";
    src = fetchurl {
      url = "mirror://sourceforge/saxon/Saxon-HE/9.9/SaxonHE9-9-0-1J.zip";
      sha256 = "1inxd7ia7rl9fxfrw8dy9sb7rqv76ipblaki5262688wf2dscs60";
    };
    description = "Processor for XSLT 3.0, XPath 2.0 and 3.1, and XQuery 3.1";
  };

  saxon-he = common {
    pname = "saxon-he";
    version = "11.5";
    prog = "saxon-he";
    jar = "saxon-he-11.5";
    src = fetchurl {
      url = "https://github.com/Saxonica/Saxon-HE/raw/a6d11dec3853326b661e9aff283e30b43c02e163/11/Java/SaxonHE11-5J.zip";
      sha256 = "2Nwh6dG3YAjc/OTr8DMOfbnRvdCWB0YsVP3ZLRbM9U0=";
    };
    description = "Processor for XSLT 3.0, XPath 2.0 and 3.1, and XQuery 3.1";
  };
}
