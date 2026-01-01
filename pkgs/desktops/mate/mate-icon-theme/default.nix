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
<<<<<<< HEAD
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
=======
  mateUpdateScript,
}:

stdenv.mkDerivation rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "mate-icon-theme";
  version = "1.28.0";

  src = fetchurl {
<<<<<<< HEAD
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor finalAttrs.version}/mate-icon-theme-${finalAttrs.version}.tar.xz";
=======
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
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
=======
  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Icon themes from MATE";
    homepage = "https://mate-desktop.org";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.mate ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
