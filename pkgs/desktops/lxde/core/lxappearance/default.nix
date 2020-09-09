{ stdenv
, fetchurl
, intltool
, pkg-config
, libX11
, gtk2
, gtk3
, withGtk3 ? true
}:

stdenv.mkDerivation rec {
  name = "lxappearance-0.6.3";

  src = fetchurl {
    url = "mirror://sourceforge/project/lxde/LXAppearance/${name}.tar.xz";
    sha256 = "0f4bjaamfxxdr9civvy55pa6vv9dx1hjs522gjbbgx7yp1cdh8kj";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
  ];

  buildInputs = [
    libX11
    (if withGtk3 then gtk3 else gtk2)
  ];

  patches = [
    ./lxappearance-0.6.3-xdg.system.data.dirs.patch
  ];

  configureFlags = stdenv.lib.optional withGtk3 "--enable-gtk3";

  meta = with stdenv.lib; {
    description = "Lightweight program for configuring the theme and fonts of gtk applications";
    homepage = "https://lxde.org/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hinton romildo ];
  };
}
