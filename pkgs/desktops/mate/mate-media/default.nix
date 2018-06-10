{ stdenv, fetchurl, pkgconfig, intltool, libtool, libxml2, libcanberra-gtk3, gnome3, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-media-${version}";
  version = "1.20.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "09vbw7nc91ljnxm5sbrch0w7zzn2i6qjb1b50q402niwr5b0zicr";
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
