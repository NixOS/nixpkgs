{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, alsa-lib
, dbus
, fontconfig
, libxkbcommon
, makeWrapper
, openvr
, openxr-loader
, pipewire
, pkg-config
, pulseaudio
, shaderc
, wayland
, xorg
}:

rustPlatform.buildRustPackage rec {
  pname = "wlx-overlay-s";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "galister";
    repo = "wlx-overlay-s";
    rev = "v${version}";
    hash = "sha256-9ess8/H7cByNYFNHvCi0124xCBwXk+PTNhAZKBcS08A=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "vulkano-0.34.0" = "sha256-0ZIxU2oItT35IFnS0YTVNmM775x21gXOvaahg/B9sj8=";
      "ovr_overlay-0.0.0" = "sha256-d38LqhKOp9tHbiK4eU7OPdFvkExqaJN1tB6y2qqPm9U=";
      "wlx-capture-0.3.11" = "sha256-CmFnVfA3MAYXSejn9GpuaNCRu4HiX0CN0j3aN4Pxvjw=";
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
    xorg.libX11
    xorg.libXext
    xorg.libXrandr
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
      --add-needed ${lib.getLib libxkbcommon}/lib/libxkbcommon.so.0
  '';

  meta = {
    description = "Wayland/X11 desktop overlay for SteamVR and OpenXR, Vulkan edition";
    homepage = "https://github.com/galister/wlx-overlay-s";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Scrumplex ];
    platforms = lib.platforms.linux;
    broken = stdenv.isAarch64;
    mainProgram = "wlx-overlay-s";
  };
}
