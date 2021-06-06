{ lib, stdenv
, fetchurl
, python2
, python3
, pkg-config
, readline
, gettext
, libxslt
, docbook-xsl-nons
, docbook_xml_dtd_42
, wafHook
}:

stdenv.mkDerivation rec {
  pname = "ntdb";
  version = "1.0";

  src = fetchurl {
    url = "mirror://samba/tdb/${pname}-${version}.tar.gz";
    sha256 = "0jdzgrz5sr25k83yrw7wqb3r0yj1v04z4s3lhsmnr5z6n5ifhyl1";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_42
    wafHook
    python2 # For wafHook
  ];

  buildInputs = [
    python3
    readline # required to build python
  ];

  wafPath = "buildtools/bin/waf";

  wafConfigureFlags = [
    "--bundled-libraries=NONE"
    "--builtin-libraries=replace,ccan"
  ];

  meta = with lib; {
    description = "The not-so trivial database";
    homepage = "https://tdb.samba.org/";
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
  };
}
