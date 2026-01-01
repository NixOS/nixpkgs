{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  mate-icon-theme,
  gtk2,
  gtk3,
  gtk_engines,
  gtk-engine-murrine,
  gdk-pixbuf,
  librsvg,
<<<<<<< HEAD
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
=======
  mateUpdateScript,
}:

stdenv.mkDerivation rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "mate-themes";
  version = "3.22.26";

  src = fetchurl {
<<<<<<< HEAD
    url = "https://pub.mate-desktop.org/releases/themes/${lib.versions.majorMinor finalAttrs.version}/mate-themes-${finalAttrs.version}.tar.xz";
=======
    url = "https://pub.mate-desktop.org/releases/themes/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    sha256 = "Ik6J02TrO3Pxz3VtBUlKmEIak8v1Q0miyF/GB+t1Xtc=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    gtk3
  ];

  buildInputs = [
    mate-icon-theme
    gtk2
    gtk_engines
    gdk-pixbuf
    librsvg
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  dontDropIconThemeCache = true;

  postInstall = ''
    gtk-update-icon-cache "$out"/share/icons/ContrastHigh
  '';

  enableParallelBuilding = true;

<<<<<<< HEAD
  passthru.updateScript = gitUpdater {
    url = "https://git.mate-desktop.org/mate-themes";
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    description = "Set of themes from MATE";
    homepage = "https://mate-desktop.org";
    license = with lib.licenses; [
=======
  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Set of themes from MATE";
    homepage = "https://mate-desktop.org";
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      lgpl21Plus
      lgpl3Only
      gpl3Plus
    ];
<<<<<<< HEAD
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})
=======
    platforms = platforms.unix;
    teams = [ teams.mate ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
