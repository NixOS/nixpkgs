{ stdenv
, lib
, fetchurl
, docbook_xsl
, docbook_xsl_ns
, gettext
, libxslt
, glibcLocales
, docbook_xml_dtd_45
, docbook_sgml_dtd_41
, opensp
, bash
, fetchpatch
, perl
, buildPerlPackage
, ModuleBuild
, TextWrapI18N
, LocaleGettext
, SGMLSpm
, UnicodeLineBreak
, PodParser
, YAMLTiny
, SyntaxKeywordTry
, writeShellScriptBin
}:

buildPerlPackage rec {
  pname = "po4a";
  version = "0.73";

  src = fetchurl {
    url = "https://github.com/mquinson/po4a/releases/download/v${version}/po4a-${version}.tar.gz";
    hash = "sha256-bxj4LYyyo3c5QTfqOWzD6BldbNbkVP4CGKoPDjYDjqA=";
  };

  strictDeps = true;

  nativeBuildInputs =
    # the tests for the tex-format use kpsewhich -- texlive's file finding utility.
    # We don't want to depend on texlive here, so we replace it with a minimal
    # shellscript that suffices for the tests in t/fmt/tex/, i.e. it looks up
    # article.cls to an existing file, but doesn't find article-wrong.cls.
    let
      kpsewhich-stub = writeShellScriptBin "kpsewhich"
        ''[[ $1 = "article.cls" ]] && echo /dev/null'';
    in
    [
      gettext
      libxslt
      docbook_xsl
      docbook_xsl_ns
      ModuleBuild
      docbook_xml_dtd_45
      docbook_sgml_dtd_41
      opensp
      kpsewhich-stub
      glibcLocales
    ];
  patches = [
    # Needs a patch for 5.40 until the next release
    (fetchpatch {
      url = "https://github.com/mquinson/po4a/commit/28fe52651eb8096d97d6bd3a97b3168522ba5306.patch";
      hash = "sha256-QUXxkSzcnwRvU+2y2KoBXmtfE8qTZ2BV0StkJHqZehQ=";
    })
    ];

  # TODO: TermReadKey was temporarily removed from propagatedBuildInputs to unfreeze the build
  propagatedBuildInputs = lib.optionals (!stdenv.hostPlatform.isMusl) [
    TextWrapI18N
  ] ++ [
    LocaleGettext
    SGMLSpm
    UnicodeLineBreak
    PodParser
    YAMLTiny
    SyntaxKeywordTry
  ];

  buildInputs = [ bash ];

  LC_ALL = "en_US.UTF-8";
  SGML_CATALOG_FILES = "${docbook_xml_dtd_45}/xml/dtd/docbook/catalog.xml";

  preConfigure = ''
    touch Makefile.PL
    export PERL_MB_OPT="--install_base=$out --prefix=$out"
  '';

  buildPhase = ''
    perl Build.PL --install_base=$out --install_path="lib=$out/${perl.libPrefix}"
    ./Build build
  '';

  # Disabling tests on musl
  # Void linux package have investigated the failure and tracked it down to differences in gettext behavior. They decided to disable tests.
  # https://github.com/void-linux/void-packages/pull/34029#issuecomment-973267880
  # Alpine packagers have not worried about running the tests until now:
  # https://git.alpinelinux.org/aports/tree/main/po4a/APKBUILD#n11
  #
  # Disabling tests on Darwin until https://github.com/NixOS/nixpkgs/issues/236560 is resolved.
  doCheck = (!stdenv.hostPlatform.isMusl) && (!stdenv.hostPlatform.isDarwin);

  checkPhase = ''
    export SGML_CATALOG_FILES=${docbook_sgml_dtd_41}/sgml/dtd/docbook-4.1/docbook.cat
    ./Build test
  '';

  installPhase = ''
    ./Build install
    for f in $out/bin/*; do
      substituteInPlace $f --replace "#! /usr/bin/env perl" "#!${perl}/bin/perl"
      substituteInPlace $f --replace "exec perl" "exec ${perl}/bin/perl"
    done
  '';

  meta = {
    description = "Tools for helping translation of documentation";
    homepage = "https://po4a.org";
    license = with lib.licenses; [ gpl2Plus ];
  };
}
