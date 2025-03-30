{
  lib,
  stdenv,
  fetchurl,
  unzip,
  jre,
  jre8,
  genericUpdater,
  writeShellScript,
  common-updater-scripts,
  gnused,
}:

let
  inherit (lib.versions) major majorMinor splitVersion;
  inherit (lib.strings) concatStringsSep versionAtLeast;

  common =
    {
      pname,
      version,
      src,
      description,
      java ? jre,
      prog ? null,
      jar ? null,
      license ? lib.licenses.mpl20,
      updateScript ? null,
    }:
    stdenv.mkDerivation (
      finalAttrs:
      let
        mainProgram = if prog == null then pname else prog;
        jar' = if jar == null then pname else jar;
      in
      {
        inherit pname version src;

        nativeBuildInputs = [ unzip ];

        buildCommand = ''
          unzip $src -d $out
          mkdir -p $out/bin $out/share $out/share/java
          cp -s "$out"/*.jar "$out/share/java/"  # */
          rm -rf $out/notices
          mv $out/doc $out/share
          cat > $out/bin/${mainProgram} <<EOF
          #! $shell
          export JAVA_HOME=${jre}
          exec ${jre}/bin/java -jar $out/${jar'}.jar "\$@"
          EOF
          chmod a+x $out/bin/${mainProgram}
        '';

        passthru = lib.optionalAttrs (updateScript != null) {
          inherit updateScript;
        };

        meta = with lib; {
          inherit description license mainProgram;
          homepage =
            if versionAtLeast finalAttrs.version "11" then
              "https://www.saxonica.com/products/latest.xml"
            else
              "https://www.saxonica.com/products/archive.xml";
          sourceProvenance = with sourceTypes; [ binaryBytecode ];
          maintainers = with maintainers; [ rvl ];
          platforms = platforms.all;
        };
      }
    );

  # Saxon release zipfiles and tags often use dashes instead of dots.
  dashify = version: concatStringsSep "-" (splitVersion version);

  # SaxonJ-HE release files are pushed to the Saxon-HE GitHub repository.
  # They are also available from Maven.
  #
  # Older releases were uploaded to SourceForge. They are also
  # available from the Saxon-Archive GitHub repository.
  github = {
    updateScript =
      version:
      genericUpdater {
        versionLister = writeShellScript "saxon-he-versionLister" ''
          export PATH="${
            lib.makeBinPath [
              common-updater-scripts
              gnused
            ]
          }:$PATH"
          major_ver="${major version}"
          list-git-tags --url="https://github.com/Saxonica/Saxon-HE.git" \
            | sed -En \
              -e "s/SaxonHE([0-9]+)-([0-9]+)/\1.\2/" \
              -e "/^''${major_ver:-[0-9]+}\./p"
        '';
      };

    downloadUrl =
      version:
      let
        tag = "SaxonHE${dashify version}";
        filename = "${major version}/Java/${tag}J.zip";
      in
      "https://raw.githubusercontent.com/Saxonica/Saxon-HE/${tag}/${filename}";
  };

in
{
  saxon = common rec {
    pname = "saxon";
    version = "6.5.3";
    src = fetchurl {
      url = "mirror://sourceforge/saxon/saxon${dashify version}.zip";
      sha256 = "0l5y3y2z4wqgh80f26dwwxwncs8v3nkz3nidv14z024lmk730vs3";
    };
    description = "XSLT 1.0 processor";
    # https://saxon.sourceforge.net/saxon6.5.3/conditions.html
    license = lib.licenses.mpl10;
    java = jre8;
  };

  saxonb_8_8 = common rec {
    pname = "saxonb";
    version = "8.8";
    jar = "saxon8";
    src = fetchurl {
      url = "mirror://sourceforge/saxon/saxonb${dashify version}j.zip";
      sha256 = "15bzrfyd2f1045rsp9dp4znyhmizh1pm97q8ji2bc0b43q23xsb8";
    };
    description = "Complete and conformant processor of XSLT 2.0, XQuery 1.0, and XPath 2.0";
    java = jre8;
  };

  saxonb_9_1 = common rec {
    pname = "saxonb";
    version = "9.1.0.8";
    jar = "saxon9";
    src = fetchurl {
      url = "mirror://sourceforge/saxon/Saxon-B/${version}/saxonb${dashify version}j.zip";
      sha256 = "1d39jdnwr3v3pzswm81zry6yikqlqy9dp2l2wmpqdiw00r5drg4j";
    };
    description = "Complete and conformant processor of XSLT 2.0, XQuery 1.0, and XPath 2.0";
  };

  # Saxon-HE (home edition) replaces Saxon-B as the open source
  # version of the Saxon XSLT and XQuery processor.
  saxon_9-he = common rec {
    pname = "saxon-he";
    version = "9.9.0.1";
    jar = "saxon9he";
    src = fetchurl {
      url = "mirror://sourceforge/saxon/Saxon-HE/${majorMinor version}/SaxonHE${dashify version}J.zip";
      sha256 = "1inxd7ia7rl9fxfrw8dy9sb7rqv76ipblaki5262688wf2dscs60";
    };
    description = "Processor for XSLT 3.0, XPath 2.0 and 3.1, and XQuery 3.1";
  };

  saxon_11-he = common rec {
    pname = "saxon-he";
    version = "11.6";
    jar = "saxon-he-${version}";
    src = fetchurl {
      url = github.downloadUrl version;
      sha256 = "/AVX5mtZSO6Is19t3+FlEvtIBsnwB3MIWAPCht8Aqnw=";
    };
    updateScript = github.updateScript version;
    description = "Processor for XSLT 3.0, XPath 2.0 and 3.1, and XQuery 3.1";
  };

  saxon_12-he = common rec {
    pname = "saxon-he";
    version = "12.5";
    jar = "saxon-he-${version}";
    src = fetchurl {
      url = github.downloadUrl version;
      hash = "sha256-NaRnKHkr1M7C/CYtSHd7THm1ze7wPSmB46ZOyzoZ9xY=";
    };
    updateScript = github.updateScript version;
    description = "Processor for XSLT 3.0, XPath 3.1, and XQuery 3.1";
  };
}
