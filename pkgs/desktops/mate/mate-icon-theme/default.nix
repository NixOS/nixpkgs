{ stdenv, fetchurl, pkgconfig, intltool, iconnamingutils, librsvg, hicolor-icon-theme, gtk3 }:

stdenv.mkDerivation rec {
  name = "mate-icon-theme-${version}";
  version = "1.22.1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1pn1xbmr4w4mi45nwk1qh18z9rlngmkhp9bw671yn4k6sii8fi3k";
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
