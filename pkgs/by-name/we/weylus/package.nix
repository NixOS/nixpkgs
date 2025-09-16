{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  dbus,
  ffmpeg,
  x264,
  libva,
  gst_all_1,
  xorg,
  libdrm,
  pkg-config,
  pango,
  pipewire,
  cmake,
  git,
  autoconf,
  libtool,
  typescript,
  wayland,
  libxkbcommon,
}:

rustPlatform.buildRustPackage {
  pname = "weylus";
  version = "unstable-2025-02-24";

  src = fetchFromGitHub {
    owner = "H-M-H";
    repo = "weylus";
    rev = "5202806798ccca67c24da52ba51ee50b973b7089";
    sha256 = "sha256-lx1ZVp5DkQiL9/vw6PAZ34Lge+K8dfEVh6vLnCUNf7M=";
  };

  buildInputs = [
    ffmpeg
    x264
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    dbus
    libva
    gst_all_1.gst-plugins-base
    xorg.libXext
    xorg.libXft
    xorg.libXinerama
    xorg.libXcursor
    xorg.libXrender
    xorg.libXfixes
    xorg.libXtst
    xorg.libXrandr
    xorg.libXcomposite
    xorg.libXi
    xorg.libXv
    pango
    libdrm
    wayland
    libxkbcommon
  ];

  nativeBuildInputs = [
    cmake
    git
    typescript
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
    autoconf
    libtool
  ];

  cargoHash = "sha256-dLhlYOrLjoBSRGDJB0qTEIb+oGnp9X+ADHddpYITdl8=";

  cargoBuildFlags = [ "--features=ffmpeg-system" ];
  cargoTestFlags = [ "--features=ffmpeg-system" ];

  postFixup =
    let
      GST_PLUGIN_PATH = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
        gst_all_1.gst-plugins-base
        pipewire
      ];
    in
    lib.optionalString stdenv.hostPlatform.isLinux ''
      wrapProgram $out/bin/weylus --prefix GST_PLUGIN_PATH : ${GST_PLUGIN_PATH}
    '';

  postInstall = ''
    install -vDm755 weylus.desktop $out/share/applications/weylus.desktop
  '';

  env = {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-incompatible-pointer-types"
    ];
  };

  meta = with lib; {
    description = "Use your tablet as graphic tablet/touch screen on your computer";
    mainProgram = "weylus";
    homepage = "https://github.com/H-M-H/Weylus";
    license = with licenses; [ agpl3Only ];
    maintainers = with maintainers; [ lom ];
  };
}
