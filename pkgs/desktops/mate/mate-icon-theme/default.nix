{ stdenv, fetchurl, pkgconfig, intltool, iconnamingutils, librsvg, hicolor-icon-theme, gtk3, mate }:

stdenv.mkDerivation rec {
  name = "mate-icon-theme-${version}";
  version = "1.20.1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "1xzlwmwz1jnksa4rs0smkxhqv3j50y78cf9y5g6aki9iw4dvhvva";
  };

  nativeBuildInputs = [ pkgconfig intltool iconnamingutils ];

  buildInputs = [ librsvg hicolor-icon-theme ];

  postInstall = ''
    for theme in "$out"/share/icons/*; do
      "${gtk3.out}/bin/gtk-update-icon-cache" "$theme"
    done
  '';

  meta = {
    description = "Icon themes from MATE";
    homepage = http://mate-desktop.org;
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
