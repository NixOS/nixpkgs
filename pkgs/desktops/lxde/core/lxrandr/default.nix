{ stdenv, fetchurl, pkgconfig, intltool, gtk2, libX11, xrandr, withGtk3 ? false, gtk3 }:

stdenv.mkDerivation rec {
  name = "lxrandr-0.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/lxde/${name}.tar.xz";
    sha256 = "6d98338485a90d9e47f6d08184df77ca0d9715517f8a45a914e861750589184e";
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
