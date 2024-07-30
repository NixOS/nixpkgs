{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, alsa-lib
, dbus
, fontconfig
, libxkbcommon
, makeWrapper
, nix-update-script
, openvr
, openxr-loader
, pipewire
, pkg-config
, pulseaudio
, shaderc
, testers
, wayland
, wlx-overlay-s
, xorg
}:

rustPlatform.buildRustPackage rec {
  pname = "wlx-overlay-s";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "galister";
    repo = "wlx-overlay-s";
    rev = "v${version}";
    hash = "sha256-4sW/WxoN5jAomA/aFAAH8z8CAB7zsevpBllSwaQWSmU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ovr_overlay-0.0.0" = "sha256-d38LqhKOp9tHbiK4eU7OPdFvkExqaJN1tB6y2qqPm9U=";
      "vulkano-0.34.0" = "sha256-o1KP/mscMG5j3U3xtei/2nMNEh7jLedcW1P0gL9Y1Rc=";
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
    broken = stdenv.isAarch64;
    mainProgram = "wlx-overlay-s";
  };
}
