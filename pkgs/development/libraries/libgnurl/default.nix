{ lib, stdenv, fetchurl, libtool, perl, pkg-config, python3, zlib, gnutls
, libidn2, libunistring }:

stdenv.mkDerivation rec {
  pname = "libgnurl";
  version = "7.72.0";

  src = fetchurl {
    url = "mirror://gnu/gnunet/gnurl-${version}.tar.gz";
    sha256 = "1y4laraq37kw8hc8jlzgcw7y37bfd0n71q0sy3d3z6yg7zh2prxi";
  };

  nativeBuildInputs = [ libtool perl pkg-config python3 ];

  buildInputs = [ gnutls zlib libidn2 libunistring ];

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

  meta = with lib; {
    description = "Fork of libcurl used by GNUnet";
    homepage    = "https://gnunet.org/en/gnurl.html";
    maintainers = [ ];
    platforms = platforms.unix;
    license = licenses.curl;
  };
}
