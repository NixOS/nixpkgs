{ lib, stdenv, fetchurl, pkg-config, gettext, iconnamingutils, librsvg, gtk3, hicolor-icon-theme, mateUpdateScript }:

stdenv.mkDerivation rec {
  pname = "mate-icon-theme";
  version = "1.24.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0a2lz61ivwwcdznmwlmgjr6ipr9sdl5g2czbagnpxkwz8f3m77na";
  };

  nativeBuildInputs = [ pkg-config gettext iconnamingutils ];

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

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = {
    description = "Icon themes from MATE";
    homepage = "https://mate-desktop.org";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.romildo ];
  };
}
