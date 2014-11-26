{ stdenv, fetchurl, python27, pkgconfig, readline, gettext, libxslt, docbook_xsl
, docbook_xml_dtd_42
, acl ? null, heimdal ? null, libaio ? null, pam ? null, zlib ? null
, libgcrypt ? null, libcap ? null
}:

stdenv.mkDerivation rec {
  name = "talloc-2.1.1";

  src = fetchurl {
    url = "http://samba.org/ftp/talloc/${name}.tar.gz";
    sha256 = "0x31id42b425dbxv5whrqlc6dj14ph7wzs3wsp1ggi537dncwa9y";
  };

  buildInputs = [
    python27 pkgconfig readline gettext libxslt docbook_xsl docbook_xml_dtd_42
    acl heimdal libaio pam zlib libgcrypt libcap
  ];

  preConfigure = ''
    sed -i 's,#!/usr/bin/env python,#!${python27}/bin/python,g' buildtools/bin/waf
  '';

  configureFlags = [
    "--enable-talloc-compat1"
    "--bundled-libraries=NONE"
    "--builtin-libraries=replace"
  ];

  postInstall = ''
    ar qf $out/lib/libtalloc.a bin/default/talloc_5.o
  '';

  meta = with stdenv.lib; {
    description = "Hierarchical pool based memory allocator with destructors";
    homepage = http://tdb.samba.org/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.all;
  };
}
