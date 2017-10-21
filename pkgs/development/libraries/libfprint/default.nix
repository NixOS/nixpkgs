{ stdenv, fetchurl, pkgconfig, libusb, pixman, glib, nss, nspr, gdk_pixbuf }:

stdenv.mkDerivation rec {
  name = "libfprint-0.7.0";

  src = fetchurl {
    url = "https://people.freedesktop.org/~anarsoul/${name}.tar.xz";
    sha256 = "1wzi12zvdp8sw3w5pfbd9cwz6c71627bkr88rxv6gifbyj6fwgl6";
  };

  buildInputs = [ libusb pixman glib nss nspr gdk_pixbuf ];
  nativeBuildInputs = [ pkgconfig ];

  configureFlags = [ "--with-udev-rules-dir=$(out)/lib/udev/rules.d" ];

  meta = with stdenv.lib; {
    homepage = http://www.freedesktop.org/wiki/Software/fprint/libfprint/;
    description = "A library designed to make it easy to add support for consumer fingerprint readers";
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
