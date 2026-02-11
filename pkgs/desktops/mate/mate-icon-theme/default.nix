{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  iconnamingutils,
  librsvg,
  gtk3,
  hicolor-icon-theme,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mate-icon-theme";
  version = "1.28.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor finalAttrs.version}/mate-icon-theme-${finalAttrs.version}.tar.xz";
    sha256 = "lNYHkGDKXfdFQpId5O6ji30C0HVhyRk1bZXeh2+abTo=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    iconnamingutils
  ];

  buildInputs = [
    librsvg
  ];

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

  passthru.updateScript = gitUpdater {
    url = "https://git.mate-desktop.org/mate-icon-theme";
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    description = "Icon themes from MATE";
    homepage = "https://mate-desktop.org";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.mate ];
  };
})
