{ stdenv, fetchurl, pkgconfig, libusb, glib, nss, nspr, gdk_pixbuf }:

stdenv.mkDerivation rec {
  name = "libfprint-0.5.1";

  src = fetchurl {
    url = "http://people.freedesktop.org/~hadess/${name}.tar.xz";
    sha256 = "1cwgaswqcvvbclahk2m2qr09k7lf7l8jwvgf3svq92w8j4xmc4kd";
  };

  buildInputs = [ libusb glib nss nspr gdk_pixbuf ];
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
