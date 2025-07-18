{
  lib,
  stdenv,
  fetchFromGitHub,
  fpc,
  lazarus,
  autoPatchelfHook,

  glib,
  cairo,
  pango,
  gtk2,
  gdk-pixbuf,
  at-spi2-atk,
  xorg,
  libnotify,

  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "tomboy-ng";
  version = "0.42";

  src = fetchFromGitHub {
    owner = "tomboy-notes";
    repo = "tomboy-ng";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ppvEZeVHJ4DHIdEXfLOWcb4Wbsi6YVKqm6NGQ7lPtdg=";
  };
  kcontrols = fetchFromGitHub {
    owner = "davidbannon";
    repo = "KControls";
    rev = "4b74f50599544aa05d76385c21795ca9026e9657";
    hash = "sha256-AHpcbt5v9Y/YG9MZ/zCLLH1Pfryv0zH8UFCgY/RqrdQ=";
    name = "kcontrols";
  };

  nativeBuildInputs = [
    fpc
    lazarus
    autoPatchelfHook
  ];

  buildInputs = [
    glib
    cairo
    pango
    gtk2
    gdk-pixbuf
    at-spi2-atk
    xorg.libX11
    libnotify
  ];

  patches = [ ./simplify-build-script.patch ];

  postPatch = "ln -s ${finalAttrs.kcontrols} kcontrols";

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  passthru.updateScript = nix-update-script {
    # Stable releases only
    extraArgs = [
      "--version-regex"
      "^v([0-9.]+)$"
    ];
  };

  env = {
    COMPILER = lib.getExe' fpc "fpc";
    LAZ_DIR = "${lazarus}/share/lazarus";
  };

  meta = {
    description = "Note taking app that works and synchronises between Linux, Windows and macOS";
    homepage = "https://github.com/tomboy-notes/tomboy-ng";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "tomboy-ng";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
