{
  lib,
  stdenv,
  fetchFromGitHub,

  meson,
  ninja,
  pkg-config,
  makeWrapper,
  wayland-scanner,

  gtk4,
  gtk4-layer-shell,
  libadwaita,
  wayland-protocols,
  ffmpeg,
  libdrm,
  pipewire,
  rubberband,
  libgbm,
  libGL,

  wl-clipboard,
  gifski,
  tesseract,

  enableOcr ? true,
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
        lib.makeBinPath (
          [
            wl-clipboard
            gifski
          ]
          ++ lib.optional enableOcr tesseract
        )
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
