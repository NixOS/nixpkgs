{ stdenv, fetchurl, pkgconfig, intltool, gtk3, gobject-introspection, libappindicator-gtk3, libindicator-gtk3, polkit, mate }:

stdenv.mkDerivation rec {
  name = "mate-polkit-${version}";
  version = "1.20.1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "05g6k5z903p9p0dbi0y61z5chip52gqrhy5zrjn6xjxv1ad29lsk";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
  ];

  buildInputs = [
    gtk3
    gobject-introspection
    libappindicator-gtk3
    libindicator-gtk3
    polkit
  ];

  meta = with stdenv.lib; {
    description = "Integrates polkit authentication for MATE desktop";
    homepage = http://mate-desktop.org;
    license = [ licenses.gpl2Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
