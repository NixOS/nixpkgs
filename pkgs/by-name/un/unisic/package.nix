{
  cmake,
  curl,
  fetchFromGitHub,
  ffmpeg,
  grim,
  kdePackages,
  leptonica,
  lib,
  libarchive,
  libinput,
  libx11,
  libxcb,
  libxext,
  libxfixes,
  ninja,
  pipewire,
  pkg-config,
  qt6,
  stdenv,
  tesseract,
  udev,
  wayland,
  wayland-scanner,
  wl-clipboard,
  zxing-cpp,
  zip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unisic";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "unisic";
    repo = "unisic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3hPiXO607oF5rYNzt1R6XEP7AswhzxjtJ6+VsOvtSfk=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.qttools
    qt6.wrapQtAppsHook
    wayland-scanner
  ];

  buildInputs = [
    curl
    kdePackages.kguiaddons
    kdePackages.layer-shell-qt
    kdePackages.plasma-wayland-protocols
    leptonica
    libarchive
    libinput
    libx11
    libxcb
    libxext
    libxfixes
    pipewire
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtmultimedia
    qt6.qtsvg
    qt6.qtwayland
    tesseract
    udev
    wayland
    zxing-cpp
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")
    (lib.cmakeBool "UNISIC_DEV_BUILD" false)
    (lib.cmakeBool "BUILD_TESTING" true)
  ];

  qtWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        curl
        ffmpeg
        grim
        pipewire
        wl-clipboard
        zip
      ]
    }"
    "--set-default TESSDATA_PREFIX ${tesseract}/share/tessdata"
  ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    export HOME=$(mktemp -d)
    export XDG_RUNTIME_DIR=$(mktemp -d)
    QT_QPA_PLATFORM=offscreen ctest --output-on-failure
    runHook postCheck
  '';

  meta = {
    description = "Screen capture, annotation, recording, and sharing tool";
    homepage = "https://unisic.app/";
    changelog = "https://github.com/unisic/unisic/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "unisic";
    platforms = lib.platforms.linux;
  };
})
