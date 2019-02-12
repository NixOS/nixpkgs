{ stdenv, fetchurl, libtool, groff, perl, pkgconfig, python2, zlib, gnutls,
  libidn2, libunistring, nghttp2 }:

stdenv.mkDerivation rec {
  version = "7.63.0";

  name = "libgnurl-${version}";

  src = fetchurl {
    url = "mirror://gnu/gnunet/gnurl-${version}.tar.gz";
    sha256 = "15y4yjy67n3c57kp0yszklcrz2nickrvjvd6laizs6kdbpixjdfl";
  };

  nativeBuildInputs = [ libtool groff perl pkgconfig python2 ];
    
  buildInputs = [ gnutls zlib libidn2 libunistring nghttp2 ];

  configureFlags = [
    "--disable-ntlm-wb"
    "--without-ca-bundle"
    "--with-ca-fallback"
  ];

  meta = with stdenv.lib; {
    description = "A fork of libcurl used by GNUnet";
    homepage    = https://gnunet.org/gnurl;
    maintainers = with maintainers; [ falsifian vrthra ];
    platforms = platforms.linux;
    license = licenses.curl;
  };
}
