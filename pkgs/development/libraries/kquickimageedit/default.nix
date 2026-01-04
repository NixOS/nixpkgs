{
  lib,
  stdenv,
  fetchFromGitLab,
  extra-cmake-modules,
  kdePackages,
  qtbase,
  qtdeclarative,
  opencv,
}:

stdenv.mkDerivation rec {
  pname = "kquickimageeditor";
  version = "0.6.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = "kquickimageeditor";
    rev = "v${version}";
    sha256 = "sha256-NhZ9aAZuIk9vUL2X7eivNbEs0zahuQpy8kl6dSdy5Lo=";
  };

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kdePackages.kirigami
    qtbase
    qtdeclarative
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
  };
}
