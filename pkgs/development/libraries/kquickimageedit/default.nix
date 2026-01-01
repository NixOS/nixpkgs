{
  lib,
  stdenv,
  fetchFromGitLab,
  extra-cmake-modules,
  kdePackages,
  qtbase,
  qtdeclarative,
<<<<<<< HEAD
  opencv,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

stdenv.mkDerivation rec {
  pname = "kquickimageeditor";
<<<<<<< HEAD
  version = "0.6.0";
=======
  version = "0.5.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = "kquickimageeditor";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-NhZ9aAZuIk9vUL2X7eivNbEs0zahuQpy8kl6dSdy5Lo=";
=======
    sha256 = "sha256-8TJBg42E9lNbLpihjtc5Z/drmmSGQmic8yO45yxSNQ4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kdePackages.kirigami
    qtbase
    qtdeclarative
<<<<<<< HEAD
    (opencv.override {
      enableCuda = false; # fails to compile, disabled in case someone sets config.cudaSupport
      enabledModules = [
        "core"
        "imgproc"
      ];
      runAccuracyTests = false; # tests will fail because of missing plugins but that's okay
    })
  ];
  dontWrapQtApps = true;

  meta = {
    description = "Set of QtQuick components providing basic image editing capabilities";
    homepage = "https://invent.kde.org/libraries/kquickimageeditor";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
=======
  ];
  dontWrapQtApps = true;

  meta = with lib; {
    description = "Set of QtQuick components providing basic image editing capabilities";
    homepage = "https://invent.kde.org/libraries/kquickimageeditor";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    badPlatforms = platforms.darwin;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
