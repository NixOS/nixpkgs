{
  lib,
  gtk4,
  stdenv,
  meson,
  ninja,
  tesseract,
  pkg-config,
  libadwaita,
  makeWrapper,
  wl-clipboard,
  fetchFromGitHub,
  gtk4-layer-shell,
  wayland-protocols,
  wayland-scanner,
  ffmpeg,
  libdrm,
  pipewire,
  rubberband,
  libgbm,
  libGL,
  gifski,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "waytator";
  version = "1.5.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "faetalize";
    repo = "waytator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yzHS4Xy6FgVEqx4zDkr1OXQRz6xht7ILkjKUnsaXm/E=";
  };

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    makeWrapper
    wayland-scanner
  ];

  buildInputs = [
    gtk4
    libadwaita
    gtk4-layer-shell
    wayland-protocols
    ffmpeg
    libdrm
    pipewire
    rubberband
    libgbm
    libGL
  ];

  postFixup = ''
    wrapProgram $out/bin/waytator \
      --prefix PATH : ${
        lib.makeBinPath [
          tesseract
          wl-clipboard
          gifski
        ]
      }
  '';

  mesonBuildType = "release";

  meta = {
    homepage = "https://github.com/faetalize/waytator";
    description = "Screenshot annotator and lightweight image and video editor";
    license = lib.licenses.gpl3Plus;
    mainProgram = "waytator";
    maintainers = with lib.maintainers; [
      _74k1
      reo101
    ];
    platforms = lib.platforms.linux;
  };
})
