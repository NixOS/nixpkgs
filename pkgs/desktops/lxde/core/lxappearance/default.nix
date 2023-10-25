{ lib, stdenv
, fetchurl
, intltool
, pkg-config
, libX11
, gtk2
, gtk3
, wrapGAppsHook
, withGtk3 ? true
}:

stdenv.mkDerivation rec {
  pname = "lxappearance";
  version = "0.6.3";

  src = fetchurl {
    url = "mirror://sourceforge/project/lxde/LXAppearance/${pname}-${version}.tar.xz";
    sha256 = "0f4bjaamfxxdr9civvy55pa6vv9dx1hjs522gjbbgx7yp1cdh8kj";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
    wrapGAppsHook
  ];

  buildInputs = [
    libX11
    (if withGtk3 then gtk3 else gtk2)
  ];

  patches = [
    ./lxappearance-0.6.3-xdg.system.data.dirs.patch
  ];

  configureFlags = lib.optional withGtk3 "--enable-gtk3";

  meta = with lib; {
    description = "Lightweight program for configuring the theme and fonts of gtk applications";
    homepage = "https://lxde.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
