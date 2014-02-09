{stdenv, fetchurl
  , zlib, libxslt, docbook_xml_dtd_45, docbook_xsl, libxml2, pcre

, autoconf, automake, libtool
}:

stdenv.mkDerivation {
  name = "qpdf-5.0.1";

  enableParallelBuilding = true;

  src = fetchurl {
    url = http://sourceforge/qpdf/qpdf/5.0.1/qpdf-5.0.1.tar.gz;
    sha256 = "1gggn5bqy61wvxw3b9dbjail7lvhzjjbiva1rh8viiba4w5qlrfh";
  };

  buildInputs = [zlib libxslt
    docbook_xml_dtd_45 docbook_xsl
    libxml2 pcre

 autoconf automake libtool
  ];

  # makeFlags: rules.mk imports libtool.mk which sets SHELL to "" for whatever reason
  preConfigure = ''
    sed -i "s@/bin/bash@$(type -p bash)@" make/libtool.mk
  '';

  meta = {
    description = "PDF is a C++ library and set of programs that inspect and manipulate the structure of PDF files. It can encrypt and linearize files, expose the internals of a PDF file, and do many other operations useful to end users and PDF developers.";
    homepage = http://sourceforge.net/projects/qpdf/;
    license = stdenv.lib.licenses.artistic2;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
