{
  lib,
  stdenv,
  fetchFromGitHub,
  fpc,
  lazarus-qt6,
  autoPatchelfHook,

  cairo,
  pango,
  qt6Packages,
  gdk-pixbuf,
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
    lazarus-qt6
    autoPatchelfHook
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    cairo
    pango
    qt6Packages.qtbase
    qt6Packages.libqtpas
    gdk-pixbuf
    libnotify
  ];

  patches = [ ./simplify-build-script.patch ];

  postPatch = "ln -s ${finalAttrs.kcontrols} kcontrols";

  # The build script checks for magic files like `Qt5` or `Qt6`
  # in order to determine which graphical toolkit tomboy-ng will
  # be built on. Yes, this is something that upstream actually does:
  # https://github.com/tomboy-notes/tomboy-ng/blob/619da85e4e11a7d20cd7f050b6b9d960a0e11a38/scripts/PKGBUILD.Qt6#L74
  preBuild = ''
    touch Qt6
  '';

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
    LAZ_DIR = "${lazarus-qt6}/share/lazarus";
  };

  meta = {
    description = "Note taking app that works and synchronises between Linux, Windows and macOS";
    homepage = "https://github.com/tomboy-notes/tomboy-ng";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "tomboy-ng";
    platforms = lib.platforms.unix;
  };
})
