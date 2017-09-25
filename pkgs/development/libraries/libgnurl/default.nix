{ stdenv, fetchurl, autoreconfHook, perl, zlib, gnutls, gss, openssl
, libssh2, libidn, libpsl, openldap }:

stdenv.mkDerivation rec {
  version = "7.54.1";

  name = "libgnurl-${version}";

  src = fetchurl {
    url = "https://gnunet.org/sites/default/files/gnurl-${version}.tar.bz2";
    sha256 = "0szbj352h95sgc9kbx9wzkgjksmg3g5k6cvlc7hz3wrbdh5gb0a4";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ perl gnutls gss openssl zlib libidn libssh2 libpsl openldap ];

  preConfigure = ''
    sed -e 's|/usr/bin|/no-such-path|g' -i.bak configure
  '';

  configureFlags = [
    "--with-zlib"
    "--with-gssapi"
    "--with-libssh2"
    "--with-libidn"
    "--with-libpsl"
    "--enable-ldap"
    "--enable-ldaps"
  ];

  meta = with stdenv.lib; {
    description = "A fork of libcurl used by GNUnet";
    homepage    = https://gnunet.org/gnurl;
    maintainers = with maintainers; [ falsifian vrthra ];
    platforms = platforms.linux;
  };
}
