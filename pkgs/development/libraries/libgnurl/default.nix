{ stdenv, fetchurl, libtool, groff, perl, pkgconfig, python2, zlib, gnutls,
  libidn2, libunistring, nghttp2 }:

stdenv.mkDerivation rec {
  pname = "libgnurl";
  version = "7.70.0";

  src = fetchurl {
    url = "mirror://gnu/gnunet/gnurl-${version}.tar.gz";
    sha256 = "0px9la8v4bj1dzxb95fx3yxk0rcjqjrxpj733ga27cza45wwzkqa";
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
