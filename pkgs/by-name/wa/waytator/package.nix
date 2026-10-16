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
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "waytator";
  version = "1.2.5";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "faetalize";
    repo = "waytator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sv7UwNsW+UTIGLDIz4JwRpPU6t5bolsz/n4bO68dDi0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    gtk4
    libadwaita
  ];

  postFixup = ''
    wrapProgram $out/bin/waytator \
      --prefix PATH : ${
        lib.makeBinPath [
          tesseract
          wl-clipboard
        ]
      }
  '';

  mesonBuildType = "release";

  meta = {
    homepage = "https://github.com/faetalize/waytator";
    description = "Screenshot annotator and lightweight image editor";
    license = lib.licenses.gpl3Plus;
    mainProgram = "waytator";
    maintainers = with lib.maintainers; [
      _74k1
      reo101
    ];
    platforms = lib.platforms.linux;
  };
})
