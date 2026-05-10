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
  libxv,
  libxtst,
  libxrender,
  libxrandr,
  libxi,
  libxinerama,
  libxft,
  libxfixes,
  libxext,
  libxcursor,
  libxcomposite,
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
  version = "unstable-2025-10-08";

  src = fetchFromGitHub {
    owner = "H-M-H";
    repo = "weylus";
    rev = "56e29ecbde3a4aba994a9df047b5398feb447c1b";
    hash = "sha256-dHdgWrygSXqKf9fpYRVDj+Ql97Or/kjBfN/mECy2ipc=";
  };

  buildInputs = [
    ffmpeg
    x264
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    dbus
    libva
    gst_all_1.gst-plugins-base
    libxext
    libxft
    libxinerama
    libxcursor
    libxrender
    libxfixes
    libxtst
    libxrandr
    libxcomposite
    libxi
    libxv
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

  cargoHash = "sha256-Mx8/zMG36qztbFYgqC7SB75bf8T0NkYQA+2Hs9/pnjk=";

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

  meta = {
    description = "Use your tablet as graphic tablet/touch screen on your computer";
    mainProgram = "weylus";
    homepage = "https://github.com/H-M-H/Weylus";
    license = with lib.licenses; [ agpl3Only ];
    maintainers = [ ];
  };
}
