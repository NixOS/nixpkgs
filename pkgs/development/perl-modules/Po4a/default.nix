{ lib, fetchurl, docbook_xsl, docbook_xsl_ns, gettext, libxslt, glibcLocales, docbook_xml_dtd_412, docbook_sgml_dtd_41, texlive, opensp
, perl, buildPerlPackage, ModuleBuild, TextWrapI18N, LocaleGettext, TermReadKey, SGMLSpm, UnicodeLineBreak, PodParser, YAMLTiny }:

buildPerlPackage rec {
  pname = "po4a";
  version = "0.55";
  src = fetchurl {
    url = "https://github.com/mquinson/po4a/releases/download/v${version}/po4a-${version}.tar.gz";
    sha256 = "1qss4q5df3nsydsbggb7gg50bn0kdxq5wn8riqm9zwkiq6a4bifg";
  };
  nativeBuildInputs = [ docbook_xsl docbook_xsl_ns ModuleBuild ];
  propagatedBuildInputs = [ TextWrapI18N LocaleGettext TermReadKey SGMLSpm UnicodeLineBreak PodParser YAMLTiny ];
  buildInputs = [ gettext libxslt glibcLocales docbook_xml_dtd_412 docbook_sgml_dtd_41 texlive.combined.scheme-basic opensp ];
  LC_ALL = "en_US.UTF-8";
  SGML_CATALOG_FILES = "${docbook_xml_dtd_412}/xml/dtd/docbook/catalog.xml";
  preConfigure = ''
    touch Makefile.PL
    export PERL_MB_OPT="--install_base=$out --prefix=$out"
  '';
  buildPhase = "perl Build.PL --install_base=$out --install_path=\"lib=$out/${perl.libPrefix}\"; ./Build build";
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
    homepage = "https://po4a.org/";
    description = "Tools for helping translation of documentation";
    license = lib.licenses.gpl2;
  };
}
