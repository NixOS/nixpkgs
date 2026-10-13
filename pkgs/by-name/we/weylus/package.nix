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
  yq-go,
  typescript_7,
  wayland,
  libxkbcommon,
  unstableGitUpdater,
}:

rustPlatform.buildRustPackage {
  pname = "weylus";
  version = "0.11.4-unstable-2026-2-16";

  src = fetchFromGitHub {
    owner = "H-M-H";
    repo = "weylus";
    rev = "38a01a8f8e429500c7e9f67fc1c88ca37a4d1e93";
    hash = "sha256-kcFXwrxg9PQxR4/71s10TMtaFvksuQaNReSoGBbrdM0=";
  };

  postPatch = ''
    yq -i '.compilerOptions += {"strict": false, "rootDir": "ts"}' tsconfig.json
  '';

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
    yq-go
    typescript_7
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
    autoconf
    libtool
  ];

  cargoHash = "sha256-2K+zLgZ3ApTCpj/OYy0f80pkvXPaB6TJe4fcrqsxPPw=";

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

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
  };

  meta = {
    description = "Use your tablet as graphic tablet/touch screen on your computer";
    mainProgram = "weylus";
    homepage = "https://github.com/H-M-H/Weylus";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.zainkergaye ];
  };
}
