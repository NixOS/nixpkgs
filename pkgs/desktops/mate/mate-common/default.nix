{
  lib,
  stdenvNoCC,
  fetchurl,
<<<<<<< HEAD
  gitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
=======
  mateUpdateScript,
}:

stdenvNoCC.mkDerivation rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "mate-common";
  version = "1.28.0";

  src = fetchurl {
<<<<<<< HEAD
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor finalAttrs.version}/mate-common-${finalAttrs.version}.tar.xz";
=======
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    sha256 = "QrfCzuJo9x1+HBrU9pvNoOzWVXipZyIYfGt2N40mugo=";
  };

  enableParallelBuilding = true;

<<<<<<< HEAD
  passthru.updateScript = gitUpdater {
    url = "https://git.mate-desktop.org/mate-common";
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    description = "Common files for development of MATE packages";
    homepage = "https://mate-desktop.org";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})
=======
  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Common files for development of MATE packages";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    teams = [ teams.mate ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
