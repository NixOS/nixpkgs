{ stdenv, fetchurl, pkgconfig, intltool, gtk2, libX11, xrandr, withGtk3 ? false, gtk3 }:

stdenv.mkDerivation rec {
  name = "lxrandr-0.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/lxde/${name}.tar.xz";
    sha256 = "04n3vgh3ix12p8jfs4w0dyfq3anbjy33h7g53wbbqqc0f74xyplb";
  };

  configureFlags = stdenv.lib.optional withGtk3 "--enable-gtk3";

  nativeBuildInputs = [ pkgconfig intltool ];
  buildInputs = [ libX11 (if withGtk3 then gtk3 else gtk2) xrandr ];

  meta = with stdenv.lib; {
    description = "LXRandR is the standard screen manager of LXDE.";
    homepage = https://lxde.org/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with maintainers; [ rawkode ];
    platforms = stdenv.lib.platforms.linux;
  };
}
