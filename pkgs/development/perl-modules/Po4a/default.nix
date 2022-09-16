{ stdenv, lib, fetchurl, docbook_xsl, docbook_xsl_ns, gettext, libxslt, glibcLocales, docbook_xml_dtd_412, docbook_sgml_dtd_41, texlive, opensp
, perl, buildPerlPackage, ModuleBuild, TextWrapI18N, LocaleGettext, TermReadKey, SGMLSpm, UnicodeLineBreak, PodParser, YAMLTiny }:

buildPerlPackage rec {
  pname = "po4a";
  version = "0.62";
  src = fetchurl {
    url = "https://github.com/mquinson/po4a/releases/download/v${version}/po4a-${version}.tar.gz";
    sha256 = "0eb510a66f59de68cf7a205342036cc9fc08b39334b91f1456421a5f3359e68b";
  };
  nativeBuildInputs = [ docbook_xsl docbook_xsl_ns ModuleBuild ];
  propagatedBuildInputs = lib.optional (!stdenv.hostPlatform.isMusl) TextWrapI18N ++ [ LocaleGettext SGMLSpm UnicodeLineBreak PodParser YAMLTiny ];
  # TODO: TermReadKey was temporarily removed from propagatedBuildInputs to unfreeze the build
  buildInputs = [ gettext libxslt glibcLocales docbook_xml_dtd_412 docbook_sgml_dtd_41 texlive.combined.scheme-basic opensp ];
  LC_ALL = "en_US.UTF-8";
  SGML_CATALOG_FILES = "${docbook_xml_dtd_412}/xml/dtd/docbook/catalog.xml";
  preConfigure = ''
    touch Makefile.PL
    export PERL_MB_OPT="--install_base=$out --prefix=$out"
  '';
  buildPhase = "perl Build.PL --install_base=$out --install_path=\"lib=$out/${perl.libPrefix}\"; ./Build build";

  # Disabling tests on musl
  # Void linux package have investigated the failure and tracked it down to differences in gettext behavior. They decided to disable tests.
  # https://github.com/void-linux/void-packages/pull/34029#issuecomment-973267880
  # Alpine packagers have not worried about running the tests until now:
  # https://git.alpinelinux.org/aports/tree/main/po4a/APKBUILD#n11
  doCheck = !stdenv.hostPlatform.isMusl;

  checkPhase = ''
    export SGML_CATALOG_FILES=${docbook_sgml_dtd_41}/sgml/dtd/docbook-4.1/docbook.cat
    ./Build test
  '';
  installPhase = ''
    ./Build install
    for f in $out/bin/*; do
      substituteInPlace $f --replace "#! /usr/bin/env perl" "#!${perl}/bin/perl"
    done
  '';
  meta = {
    description = "Tools for helping translation of documentation";
    homepage = "https://po4a.org";
    license = with lib.licenses; [ gpl2Only ];
  };
}
