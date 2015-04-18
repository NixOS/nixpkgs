{ stdenv, fetchurl, pkgconfig, libusb, pixman, glib, nss, nspr, gdk_pixbuf }:

stdenv.mkDerivation rec {
  name = "libfprint-0.6.0";

  src = fetchurl {
    url = "http://people.freedesktop.org/~hadess/${name}.tar.xz";
    sha256 = "1giwh2z63mn45galsjb59rhyrvgwcy01hvvp4g01iaa2snvzr0r5";
  };

  buildInputs = [ libusb pixman glib nss nspr gdk_pixbuf ];
  nativeBuildInputs = [ pkgconfig ];

  configureFlags = [ "--with-udev-rules-dir=$(out)/lib/udev/rules.d" ];

  meta = with stdenv.lib; {
    homepage = "http://www.freedesktop.org/wiki/Software/fprint/libfprint/";
    description = "A library designed to make it easy to add support for consumer fingerprint readers";
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
