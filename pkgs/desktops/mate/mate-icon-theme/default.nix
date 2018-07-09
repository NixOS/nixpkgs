{ stdenv, fetchurl, pkgconfig, intltool, iconnamingutils, librsvg, hicolor-icon-theme, gtk3, mate }:

stdenv.mkDerivation rec {
  name = "mate-icon-theme-${version}";
  version = "1.21.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "170vir6h9sgsibd4kfq5qgz542qrw94q3qakqry77clls5wj6b62";
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
