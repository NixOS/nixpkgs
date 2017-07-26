{ stdenv, fetchurl, pkgconfig, udev, glib }:

stdenv.mkDerivation rec {
  name = "libgudev-${version}";
  version = "231";

  src = fetchurl {
    url = "https://download.gnome.org/sources/libgudev/${version}/${name}.tar.xz";
    sha256 = "15iz0qp57qy5pjrblsn36l0chlncqggqsg8h8i8c71499afzj7iv";
  };

  buildInputs = [ pkgconfig udev glib ];

  # There's a dependency cycle with umockdev and the tests fail to LD_PRELOAD anyway.
  configureFlags = [ "--disable-umockdev" ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/libgudev;
    maintainers = [ maintainers.eelco ];
    platforms = platforms.linux;
    license = licenses.lgpl2Plus;
  };
}
