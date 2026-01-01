{
  lib,
  stdenvNoCC,
  fetchurl,
  meson,
  ninja,
  gettext,
<<<<<<< HEAD
  gitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
=======
  mateUpdateScript,
}:

stdenvNoCC.mkDerivation rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "mate-backgrounds";
  version = "1.28.0";

  src = fetchurl {
<<<<<<< HEAD
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor finalAttrs.version}/mate-backgrounds-${finalAttrs.version}.tar.xz";
=======
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    sha256 = "UNGv0CSGvQesIqWmtu+jAxFI8NSKguSI2QmtVwA6aUM=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
  ];

<<<<<<< HEAD
  passthru.updateScript = gitUpdater {
    url = "https://git.mate-desktop.org/mate-backgrounds";
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    description = "Background images and data for MATE";
    homepage = "https://mate-desktop.org";
    license = with lib.licenses; [
      gpl2Plus
      cc-by-sa-40
    ];
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})
=======
  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Background images and data for MATE";
    homepage = "https://mate-desktop.org";
    license = with licenses; [
      gpl2Plus
      cc-by-sa-40
    ];
    platforms = platforms.unix;
    teams = [ teams.mate ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
