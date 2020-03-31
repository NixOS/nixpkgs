{ stdenv
, fetchurl
, python
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
}:

stdenv.mkDerivation rec {
  pname = "ldb";
  version = "1.3.3";

  src = fetchurl {
    url = "mirror://samba/ldb/${pname}-${version}.tar.gz";
    sha256 = "14gsrm7dvyjpbpnc60z75j6fz2p187abm2h353lq95kx2bv70c1b";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    pkg-config
    wafHook
  ];

  buildInputs = [
    python
    readline
    tdb
    talloc
    tevent
    popt
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_42
    cmocka
  ];

  patches = [
    # CVE-2019-3824
    # downloading the patch from debian as they have ported the patch from samba to ldb but otherwise is identical to
    # https://bugzilla.samba.org/attachment.cgi?id=14857
    (fetchurl {
      name = "CVE-2019-3824.patch";
      url = "https://sources.debian.org/data/main/l/ldb/2:1.1.27-1+deb9u1/debian/patches/CVE-2019-3824-master-v4-5-02.patch";
      sha256 = "1idnqckvjh18rh9sbq90rr4sxfviha9nd1ca9pd6lai0y6r6q4yd";
    })
  ];

  wafPath = "buildtools/bin/waf";

  wafConfigureFlags = [
    "--bundled-libraries=NONE"
    "--builtin-libraries=replace"
  ];

  stripDebugList = "bin lib modules";

  meta = with stdenv.lib; {
    description = "A LDAP-like embedded database";
    homepage = "https://ldb.samba.org/";
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
  };
}
