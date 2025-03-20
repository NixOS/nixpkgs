{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  scdoc,
  wayland-scanner,
  wayland,
  wayland-protocols,
  ffmpeg,
  x264,
  libpulseaudio,
  pipewire,
  libgbm,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "wf-recorder";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "ammen99";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7/fQOkfAw5v3irD5blJOdq88j0VBrPVQQufdt9wsACk=";
  };

  patches = [
    # compile fixes from upstream, remove when they stop applying
    (fetchpatch {
      url = "https://github.com/ammen99/wf-recorder/commit/560bb92d3ddaeb31d7af77d22d01b0050b45bebe.diff";
      sha256 = "sha256-7jbX5k8dh4dWfolMkZXiERuM72zVrkarsamXnd+1YoI=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
    scdoc
  ];
  buildInputs = [
    wayland
    wayland-protocols
    ffmpeg
    x264
    libpulseaudio
    pipewire
    libgbm
  ];

  meta = with lib; {
    description = "Utility program for screen recording of wlroots-based compositors";
    inherit (src.meta) homepage;
    changelog = "https://github.com/ammen99/wf-recorder/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.linux;
    mainProgram = "wf-recorder";
  };
}
