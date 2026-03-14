{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  ninja,
  pkg-config,
  fmt_11,
  spdlog,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "tt-logger";
  version = "1.1.8";

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "tt-logger";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cAQLxxwxRkRh1hwDVyDPOr3wsiC2DStUP0UMSiY0vHg=";
  };

  cpm = fetchurl {
    url = "https://github.com/cpm-cmake/CPM.cmake/releases/download/v0.40.2/CPM.cmake";
    hash = "sha256-yM3DLAOBZTjOInge1ylk3IZLKjSjENO3EEgSpcotg10=";
  };

  patches = [
    # https://github.com/tenstorrent/tt-logger/pull/27
    ./fix-install.patch
  ];

  postPatch = ''
    cp $cpm cmake/CPM.cmake
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    fmt_11
    spdlog
  ];

  cmakeFlags = [
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeBool "CPM_USE_LOCAL_PACKAGES_ONLY" true)
    (lib.cmakeBool "CPM_LOCAL_PACKAGES_ONLY" true)
    (lib.cmakeBool "TT_LOGGER_INSTALL" true)
  ];

  meta = {
    description = "Flexible and performant C++ logging library for Tenstorrent projects";
    homepage = "https://github.com/tenstorrent/tt-logger";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = with lib.licenses; [ asl20 ];
    platforms = lib.platforms.linux;
  };
})
