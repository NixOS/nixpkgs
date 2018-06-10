{ stdenv, fetchurl, autoreconfHook, perl, zlib, gnutls, gss, openssl
, libidn }:

stdenv.mkDerivation rec {
  version = "7.54.1";

  name = "libgnurl-${version}";

  src = fetchurl {
    url = "https://gnunet.org/sites/default/files/gnurl-${version}.tar.bz2";
    sha256 = "0szbj352h95sgc9kbx9wzkgjksmg3g5k6cvlc7hz3wrbdh5gb0a4";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ perl gnutls gss openssl zlib libidn ];

  preConfigure = ''
    sed -e 's|/usr/bin|/no-such-path|g' -i.bak configure
  '';

  configureFlags = [
    "--enable-ipv6" "--with-gnutls" "--without-libmetalink" "--without-winidn"
    "--without-librtmp" "--without-nghttp2" "--without-nss" "--without-cyassl"
    "--without-polarssl" "--without-ssl" "--without-winssl"
    "--without-darwinssl" "--disable-sspi" "--disable-ntlm-wb" "--disable-ldap"
    "--disable-rtsp" "--disable-dict" "--disable-telnet" "--disable-tftp"
    "--disable-pop3" "--disable-imap" "--disable-smtp" "--disable-gopher"
    "--disable-file" "--disable-ftp" "--disable-smb"
  ];

  meta = with stdenv.lib; {
    description = "A fork of libcurl used by GNUnet";
    homepage    = https://gnunet.org/gnurl;
    maintainers = with maintainers; [ falsifian vrthra ];
    platforms = platforms.linux;
  };
}
