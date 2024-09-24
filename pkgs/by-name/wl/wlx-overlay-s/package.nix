{
  alsa-lib,
  dbus,
  fetchFromGitHub,
  fontconfig,
  lib,
  libGL,
  libuuid,
  libX11,
  libXext,
  libXrandr,
  libxkbcommon,
  makeWrapper,
  nix-update-script,
  openvr,
  openxr-loader,
  pipewire,
  pkg-config,
  pulseaudio,
  rustPlatform,
  shaderc,
  stdenv,
  testers,
  vulkan-loader,
  wayland,
  wlx-overlay-s,
}:

rustPlatform.buildRustPackage rec {
  pname = "wlx-overlay-s";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "galister";
    repo = "wlx-overlay-s";
    rev = "v${version}";
    hash = "sha256-FuhpHByeiUwB14+WHZ7ssJ8YPphs06jPcMhxiGfiaU8=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "libmonado-rs-0.1.0" = "sha256-ja7OW/YSmfzaQoBhu6tec9v8fyNDknLekE2eY7McLPE=";
      "openxr-0.18.0" = "sha256-ktkbhmExstkNJDYM/HYOwAwv3acex7P9SP0KMAOKhQk=";
      "ovr_overlay-0.0.0" = "sha256-5IMEI0IPTacbA/1gibYU7OT6r+Bj+hlQjDZ3Kg0L2gw=";
      "vulkano-0.34.0" = "sha256-o1KP/mscMG5j3U3xtei/2nMNEh7jLedcW1P0gL9Y1Rc=";
      "wlx-capture-0.3.12" = "sha256-32WnAnNUSfsAA8WB9da3Wqb4acVlXh6HWsY9tPzCHEE=";
    };
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    alsa-lib
    dbus
    fontconfig
    libxkbcommon
    openvr
    openxr-loader
    pipewire
    libX11
    libXext
    libXrandr
  ];

  env.SHADERC_LIB_DIR = "${lib.getLib shaderc}/lib";

  postPatch = ''
    substituteAllInPlace src/res/watch.yaml \
      --replace '"pactl"' '"${lib.getExe' pulseaudio "pactl"}"'

    # TODO: src/res/keyboard.yaml references 'whisper_stt'
  '';

  postInstall = ''
    patchelf $out/bin/wlx-overlay-s \
      --add-needed ${lib.getLib wayland}/lib/libwayland-client.so.0 \
      --add-needed ${lib.getLib libxkbcommon}/lib/libxkbcommon.so.0 \
      --add-needed ${lib.getLib libGL}/lib/libEGL.so.1 \
      --add-needed ${lib.getLib libGL}/lib/libGL.so.1 \
      --add-needed ${lib.getLib vulkan-loader}/lib/libvulkan.so.1 \
      --add-needed ${lib.getLib libuuid}/lib/libuuid.so.1
  '';

  passthru = {
    tests.testVersion = testers.testVersion { package = wlx-overlay-s; };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Wayland/X11 desktop overlay for SteamVR and OpenXR, Vulkan edition";
    homepage = "https://github.com/galister/wlx-overlay-s";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Scrumplex ];
    platforms = lib.platforms.linux;
    broken = stdenv.hostPlatform.isAarch64;
    mainProgram = "wlx-overlay-s";
  };
}
