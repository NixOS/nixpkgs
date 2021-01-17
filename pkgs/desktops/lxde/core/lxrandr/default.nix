{ lib, stdenv, fetchurl, pkg-config, intltool, gtk2, libX11, xrandr, withGtk3 ? false, gtk3 }:

stdenv.mkDerivation rec {
  name = "lxrandr-0.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/lxde/${name}.tar.xz";
    sha256 = "04n3vgh3ix12p8jfs4w0dyfq3anbjy33h7g53wbbqqc0f74xyplb";
  };

  configureFlags = lib.optional withGtk3 "--enable-gtk3";

  nativeBuildInputs = [ pkg-config intltool ];
  buildInputs = [ libX11 (if withGtk3 then gtk3 else gtk2) xrandr ];

  meta = with lib; {
    description = "Standard screen manager of LXDE";
    homepage = "https://lxde.org/";
    license = lib.licenses.gpl2;
    maintainers = with maintainers; [ rawkode ];
    platforms = lib.platforms.linux;
  };
}
