{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  ninja,
  qt6,
  spdlog,
  zlib-ng,
  minizip-ng,
  libbass,
  libbassmidi,
  unstableGitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vgmtrans-beta";
  version = "1.2-unstable-2025-05-27";

  src = fetchFromGitHub {
    owner = "vgmtrans";
    repo = "vgmtrans";
    rev = "69da9a776a537f0a79717586399da193d4161107";
    hash = "sha256-7OvbD1ygcNa+uKMqcUmhnIoWfXVOA24b7IkbjXsLvw8=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    libbass
    libbassmidi
  ];

  preConfigure = ''
    rm -r lib/{spdlog,zlib-ng,minizip-ng}
    ln -s ${spdlog.src} lib/spdlog
    ln -s ${zlib-ng.src} lib/zlib-ng
    ln -s ${minizip-ng.src} lib/minizip-ng
  '';

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
  };

  meta = {
    description = "Tool to convert proprietary, sequenced videogame music to industry-standard formats";
    homepage = "https://github.com/vgmtrans/vgmtrans";
    license = with lib.licenses; [
      zlib
      libpng
      bsd3 # oki_adpcm_state
    ];
    # See CMakePresets.json
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
      "x86_64-windows"
      "aarch64-windows"
    ];
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "vgmtrans";
  };
})
