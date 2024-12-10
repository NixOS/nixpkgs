{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  alsa-lib,
  dbus,
  fontconfig,
  libxkbcommon,
  makeWrapper,
  openvr,
  openxr-loader,
  pipewire,
  pkg-config,
  pulseaudio,
  shaderc,
  wayland,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "wlx-overlay-s";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "galister";
    repo = "wlx-overlay-s";
    rev = "v${version}";
    hash = "sha256-5uvdLBUnc8ba6b/dJNWsuqjnbbidaCcqgvSafFEXaMU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ovr_overlay-0.0.0" = "sha256-b2sGzBOB2aNNJ0dsDBjgV2jH3ROO/Cdu8AIHPSXMCPg=";
      "vulkano-0.34.0" = "sha256-0ZIxU2oItT35IFnS0YTVNmM775x21gXOvaahg/B9sj8=";
      "wlx-capture-0.3.1" = "sha256-kK3OQMdIqCLZlgZuevNtfMDmpR8J2DFFD8jRHHWAvSA=";
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

  meta = with lib; {
    description = "Wayland/X11 desktop overlay for SteamVR and OpenXR, Vulkan edition";
    homepage = "https://github.com/galister/wlx-overlay-s";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Scrumplex ];
    platforms = platforms.linux;
    broken = stdenv.isAarch64;
    mainProgram = "wlx-overlay-s";
  };
}
