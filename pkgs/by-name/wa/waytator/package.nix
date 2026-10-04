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
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "waytator";
  version = "1.2.4";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "faetalize";
    repo = "waytator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/Tq4fVrgss/v/+ugAueWCx1mbQlsyQ0LE4jRtIhT4qU=";
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
      --prefix PATH : ${lib.makeBinPath [ tesseract ]}
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
