{ stdenv, fetchurl, pkgconfig, libsoup, glib }:

stdenv.mkDerivation rec {
  name = "gssdp-${version}";
  version = "1.0.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gssdp/1.0/${name}.tar.xz";
    sha256 = "1p1m2m3ndzr2whipqw4vfb6s6ia0g7rnzzc4pnq8b8g1qw4prqd1";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libsoup ];
  propagatedBuildInputs = [ glib ];

  meta = with stdenv.lib; {
    description = "GObject-based API for handling resource discovery and announcement over SSDP";
    homepage = http://www.gupnp.org/;
    license = licenses.lgpl2;
    platforms = platforms.all;
  };
}
