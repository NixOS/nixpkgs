{ stdenv, fetchurl, pkgconfig, gettext, iconnamingutils, librsvg, gtk3, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "mate-icon-theme";
  version = "1.24.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0a2lz61ivwwcdznmwlmgjr6ipr9sdl5g2czbagnpxkwz8f3m77na";
  };

  nativeBuildInputs = [ pkgconfig gettext iconnamingutils ];

  buildInputs = [ librsvg ];

  propagatedBuildInputs = [
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  postInstall = ''
    for theme in "$out"/share/icons/*; do
      "${gtk3.out}/bin/gtk-update-icon-cache" "$theme"
    done
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Icon themes from MATE";
    homepage = "https://mate-desktop.org";
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
