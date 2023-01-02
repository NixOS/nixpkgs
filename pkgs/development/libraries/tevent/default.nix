{ lib, stdenv
, fetchurl
, python3
, pkg-config
, cmocka
, readline
, talloc
, libxslt
, docbook-xsl-nons
, docbook_xml_dtd_42
, which
, wafHook
}:

stdenv.mkDerivation rec {
  pname = "tevent";
  version = "0.13.0";

  src = fetchurl {
    url = "mirror://samba/tevent/${pname}-${version}.tar.gz";
    sha256 = "sha256-uUN6kX+lU0Q2G+tk7J4AQumcroh5iCpi3Tj2q+I3HQw=";
  };

  nativeBuildInputs = [
    pkg-config
    which
    python3
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_42
    wafHook
  ];

  buildInputs = [
    python3
    cmocka
    readline # required to build python
    talloc
  ];

  # otherwise the configure script fails with
  # PYTHONHASHSEED=1 missing! Don't use waf directly, use ./configure and make!
  preConfigure = ''
    export PKGCONFIG="$PKG_CONFIG"
    export PYTHONHASHSEED=1
  '';

  wafPath = "buildtools/bin/waf";

  wafConfigureFlags = [
    "--bundled-libraries=NONE"
    "--builtin-libraries=replace"
  ];

  meta = with lib; {
    description = "An event system based on the talloc memory management library";
    homepage = "https://tevent.samba.org/";
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
  };
}
