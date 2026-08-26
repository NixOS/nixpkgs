{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  kdePackages,
  qtbase,
  qtdeclarative,
  opencv,
}:

stdenv.mkDerivation rec {
  pname = "kquickimageeditor";
  version = "0.6.2";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = "kquickimageeditor";
    rev = "v${version}";
    sha256 = "sha256-xRs1kURy+ScuV5v8Yxn+PRRL+dnRi6/p0VyeDwLZzv8=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
  ];
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
