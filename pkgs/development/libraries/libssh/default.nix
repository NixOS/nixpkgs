{ stdenv, fetchurl, pkgconfig, cmake, zlib, libgcrypt, openssl }:

stdenv.mkDerivation rec {
  name = "libssh-0.6.4";

  src = fetchurl {
    url = "https://red.libssh.org/attachments/download/107/${name}.tar.gz";
    sha256 = "0lkb45sc7w0wd67p46yh8rsprglssnkqar1sp0impwsvx7i0acky";
  };

  # option we don't provide (yet): use libgcrypt instead of openssl
  buildInputs = [ zlib /*libgcrypt*/ openssl ];

  nativeBuildInputs = [ cmake pkgconfig ];

  meta = with stdenv.lib; {
    description = "SSH client library";
    license = licenses.lgpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ sander urkud ];
    platforms = platforms.all;
  };
}
