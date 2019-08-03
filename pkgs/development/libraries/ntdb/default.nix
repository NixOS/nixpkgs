{ stdenv, fetchurl, python, pkgconfig, readline, gettext, libxslt
, docbook_xsl, docbook_xml_dtd_42
}:

stdenv.mkDerivation rec {
  name = "ntdb-1.0";

  src = fetchurl {
    url = "mirror://samba/tdb/${name}.tar.gz";
    sha256 = "0jdzgrz5sr25k83yrw7wqb3r0yj1v04z4s3lhsmnr5z6n5ifhyl1";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    python readline gettext libxslt docbook_xsl docbook_xml_dtd_42
  ];

  preConfigure = ''
    patchShebangs buildtools/bin/waf
  '';

  configureFlags = [
    "--bundled-libraries=NONE"
    "--builtin-libraries=replace,ccan"
  ];

  meta = with stdenv.lib; {
    description = "The not-so trivial database";
    homepage = https://tdb.samba.org/;
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
  };
}
