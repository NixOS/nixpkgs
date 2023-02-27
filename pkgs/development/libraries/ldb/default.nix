{ lib, stdenv
, fetchurl
, python3
, pkg-config
, readline
, tdb
, talloc
, tevent
, popt
, libxslt
, docbook-xsl-nons
, docbook_xml_dtd_42
, cmocka
, wafHook
, libxcrypt
}:

stdenv.mkDerivation rec {
  pname = "ldb";
  version = "2.6.1";

  src = fetchurl {
    url = "mirror://samba/ldb/${pname}-${version}.tar.gz";
    sha256 = "sha256-RnQD9334Z4LDlluxdUQLqi7XUan+uVYBlL2MBr8XNsk=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    pkg-config
    python3
    wafHook
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_42
    tdb
    tevent
  ];

  buildInputs = [
    python3
    readline # required to build python
    tdb
    talloc
    tevent
    popt
    cmocka
    libxcrypt
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
    "--without-ldb-lmdb"
  ];

  stripDebugList = [ "bin" "lib" "modules" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A LDAP-like embedded database";
    homepage = "https://ldb.samba.org/";
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
  };
}
