{
  lib,
  stdenv,
  config,
  fetchFromGitHub,
  cmake,
  pkg-config,
  openssl,
  zeromq,
  cppzmq,
  onetbb,
  spdlog,
  libsodium,
  fmt,
  vips,
  nlohmann_json,
  libsixel,
  microsoft-gsl,
  chafa,
  cli11,
  libexif,
  range-v3,
  enableOpencv ? stdenv.hostPlatform.isLinux,
  opencv,
  enableWayland ? stdenv.hostPlatform.isLinux,
  extra-cmake-modules,
  wayland,
  wayland-protocols,
  wayland-scanner,
  enableX11 ? stdenv.hostPlatform.isLinux,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ueberzugpp";
  version = "2.9.8";

  src = fetchFromGitHub {
    owner = "jstkdng";
    repo = "ueberzugpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BTOuOS0zCdYTTc47UHaGI6wqFEv6e71cD2XBZtnKGLU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals enableWayland [
    wayland-scanner
  ];

  buildInputs = [
    openssl
    zeromq
    cppzmq
    onetbb
    spdlog
    libsodium
    fmt
    vips
    nlohmann_json
    libsixel
    microsoft-gsl
    chafa
    cli11
    libexif
    range-v3
  ]
  ++ lib.optionals enableOpencv [
    opencv
  ]
  ++ lib.optionals enableWayland [
    extra-cmake-modules
    wayland
    wayland-protocols
  ]
  ++ lib.optionals enableX11 [
    xorg.libX11
    xorg.xcbutilimage
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_OPENCV" enableOpencv)
    (lib.cmakeBool "ENABLE_WAYLAND" enableWayland)
    (lib.cmakeBool "ENABLE_X11" enableX11)
  ];

  meta = {
    description = "Drop in replacement for ueberzug written in C++";
    homepage = "https://github.com/jstkdng/ueberzugpp";
    changelog = "https://github.com/jstkdng/ueberzugpp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      aleksana
      wegank
    ];
    platforms = lib.platforms.unix;
  };
})
