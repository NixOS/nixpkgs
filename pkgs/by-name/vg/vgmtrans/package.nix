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
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vgmtrans";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "vgmtrans";
    repo = "vgmtrans";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-HVC45B1DFThZRkPVrroiay+9ufkOrTMUZoNIuC1CjjM=";
  };

  patches = [
    # https://github.com/vgmtrans/vgmtrans/pull/567
    (fetchpatch2 {
      name = "fix-version-string.patch";
      url = "https://github.com/vgmtrans/vgmtrans/commit/5ad8a60a19476d2ae9a7c409b83ab6d5e1ff827f.patch?full_index=1";
      hash = "sha256-I5ykYzj3tUBQ2e3TAnCm5Ry1Hmmi2IVneFQCe5/JV/A=";
    })
  ];

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
