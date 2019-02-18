{ stdenv, fetchurl, pkgconfig, intltool, libtool, libxml2, libcanberra-gtk3, gnome3, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-media-${version}";
  version = "1.20.2";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "06fka82smrphzj4dz9dw1566kmdscxvxl0rchj9qxg7aidy0rmnv";
  };

  buildInputs = [
    libxml2
    libcanberra-gtk3
    gnome3.gtk
    mate.libmatemixer
    mate.mate-desktop
  ];

  nativeBuildInputs = [
    pkgconfig
    intltool
    libtool
    wrapGAppsHook
  ];

  meta = with stdenv.lib; {
    description = "Media tools for MATE";
    homepage = http://mate-desktop.org;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo maintainers.chpatrick ];
  };
}
