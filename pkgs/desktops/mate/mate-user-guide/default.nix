{
  lib,
  stdenv,
  fetchurl,
  gettext,
  itstool,
  libxml2,
  yelp,
<<<<<<< HEAD
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
=======
  mateUpdateScript,
}:

stdenv.mkDerivation rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "mate-user-guide";
  version = "1.28.0";

  src = fetchurl {
<<<<<<< HEAD
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor finalAttrs.version}/mate-user-guide-${finalAttrs.version}.tar.xz";
=======
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    sha256 = "U+8IFPUGVEYU7WGre+UiHMjTqfFPfvlpjJD+fkYBS54=";
  };

  nativeBuildInputs = [
    itstool
    gettext
    libxml2
  ];

  buildInputs = [
    yelp
  ];

  postPatch = ''
    substituteInPlace mate-user-guide.desktop.in.in \
      --replace-fail "Exec=yelp" "Exec=${yelp}/bin/yelp"
  '';

  enableParallelBuilding = true;

<<<<<<< HEAD
  passthru.updateScript = gitUpdater {
    url = "https://git.mate-desktop.org/mate-user-guide";
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    description = "MATE User Guide";
    homepage = "https://mate-desktop.org";
    license = with lib.licenses; [
      gpl2Plus
      fdl11Plus
    ];
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})
=======
  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "MATE User Guide";
    homepage = "https://mate-desktop.org";
    license = with licenses; [
      gpl2Plus
      fdl11Plus
    ];
    platforms = platforms.unix;
    teams = [ teams.mate ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
