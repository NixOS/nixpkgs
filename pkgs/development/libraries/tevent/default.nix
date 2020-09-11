{ stdenv
, fetchurl
, python3
, pkg-config
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
  version = "0.10.2";

  src = fetchurl {
    url = "mirror://samba/tevent/${pname}-${version}.tar.gz";
    sha256 = "15k6i8ad5lpxfjsjyq9h64zlyws8d3cm0vwdnaw8z1xjwli7hhpq";
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
    readline # required to build python
    talloc
  ];

  wafPath = "buildtools/bin/waf";

  wafConfigureFlags = [
    "--bundled-libraries=NONE"
    "--builtin-libraries=replace"
  ];

  meta = with stdenv.lib; {
    description = "An event system based on the talloc memory management library";
    homepage = "https://tevent.samba.org/";
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
  };
}
