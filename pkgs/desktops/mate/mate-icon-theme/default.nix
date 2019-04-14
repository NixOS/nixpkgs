{ stdenv, fetchurl, pkgconfig, intltool, iconnamingutils, librsvg, hicolor-icon-theme, gtk3, mate }:

stdenv.mkDerivation rec {
  name = "mate-icon-theme-${version}";
  version = "1.20.3";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "10l58mjc2a69pm7srxvlav2b8b7nbzyvwjrlrk79a3gr6dd1mbk4";
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
    homepage = https://mate-desktop.org;
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
