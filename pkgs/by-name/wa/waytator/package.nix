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
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "waytator";
  version = "1.4.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "faetalize";
    repo = "waytator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OnEUDSxKJCZsN0v2BV/QQ8ceI4BSaY9LH+QucziY1EA=";
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
