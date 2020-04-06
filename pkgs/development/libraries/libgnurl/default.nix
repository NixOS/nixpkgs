{ stdenv, fetchurl, libtool, groff, perl, pkgconfig, python2, zlib, gnutls,
  libidn2, libunistring, nghttp2 }:

stdenv.mkDerivation rec {
  pname = "libgnurl";
  version = "7.67.0";

  src = fetchurl {
    url = "mirror://gnu/gnunet/gnurl-${version}.tar.gz";
    sha256 = "0ima9hz5d54iyvvih51s8xn6dsfxd3qyzgnj9l7w9f1smia295rb";
  };

  nativeBuildInputs = [ libtool groff perl pkgconfig python2 ];

  buildInputs = [ gnutls zlib libidn2 libunistring nghttp2 ];

  configureFlags = [
    "--disable-ntlm-wb"
    "--without-ca-bundle"
    "--with-ca-fallback"
    # below options will cause errors if enabled
    "--disable-ftp"
    "--disable-tftp"
    "--disable-file"
    "--disable-ldap"
    "--disable-dict"
    "--disable-rtsp"
    "--disable-telnet"
    "--disable-pop3"
    "--disable-imap"
    "--disable-smb"
    "--disable-smtp"
    "--disable-gopher"
    "--without-ssl" # disables only openssl, not ssl in general
    "--without-libpsl"
    "--without-librtmp"
  ];

  meta = with stdenv.lib; {
    description = "A fork of libcurl used by GNUnet";
    homepage    = "https://gnunet.org/en/gnurl.html";
    maintainers = with maintainers; [ vrthra ];
    platforms = platforms.linux;
    license = licenses.curl;
  };
}
