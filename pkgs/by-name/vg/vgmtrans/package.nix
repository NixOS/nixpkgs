{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  qt6,
  spdlog,
  zlib,
  libbass,
  libbassmidi,
  xz,
  libchdr,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vgmtrans";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "vgmtrans";
    repo = "vgmtrans";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eI+AFZtw8+IND6bLytUZN7lPHe03LoqLnpP6SCnvQyQ=";
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
    xz
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_ZLIB" true)
  ];

  preConfigure = ''
    rm -r lib/{spdlog,libchdr}
    ln -s ${spdlog.src} lib/spdlog
    ln -s ${libchdr.src} lib/libchdr
    tar xzf ${zlib.src} --strip-components=1 -C lib/zlib
  '';

  meta = {
    description = "Tool to convert proprietary, sequenced videogame music to industry-standard formats";
    homepage = "https://github.com/vgmtrans/vgmtrans";
    license = [
      # it has been previously observed that package inputs will override licenses with the same name
      # it is imperative to not use `with lib.license` here.
      lib.licenses.zlib
      lib.licenses.libpng
      lib.licenses.bsd3 # oki_adpcm_state
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
