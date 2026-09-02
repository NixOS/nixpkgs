{
  lib,
  stdenv,
  fetchFromGitHub,
  libnotify,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  ncurses,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tomato-c";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "gabrielzschmitz";
    repo = "Tomato.C";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YdFwHCeYRgzCizO8G+f/9jjMDgp2CiJTH7PR2T6mRD8=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    copyDesktopItems
  ];

  buildInputs = [
    libnotify
    ncurses
  ];

  enableParallelBuilding = true;
  makeFlags = [
    "-C build"
    "DATAPREFIX=${placeholder "out"}/share/tomato"
    "PREFIX=${placeholder "out"}"
  ];

  installPhase = ''
    install -Dm755 build/${finalAttrs.meta.mainProgram} $out/bin/${finalAttrs.meta.mainProgram}
    mkdir -p $out/share/tomato/{sprites,sounds,icons}
    cp resources/sprites/*.asc $out/share/tomato/sprites/
    cp resources/sounds/*.mp3 $out/share/tomato/sounds/
    cp resources/icons/* $out/share/tomato/icons/
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Tomato.c";
      desktopName = "Pomodoro timer";
      comment = finalAttrs.meta.description;
      icon = "tomato";
      exec = finalAttrs.meta.mainProgram;
      terminal = true;
      categories = [ "Utility" ];
      keywords = [
        "pomodoro"
        "productivity"
        "timer"
      ];
    })
  ];

  strictDeps = true;

  meta = {
    homepage = "https://github.com/gabrielzschmitz/Tomato.C";
    description = "Terminal-based pomodoro timer written in pure C";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ _3JlOy-PYCCKUi ];
    mainProgram = "tomato";
    platforms = lib.platforms.unix;
  };
})
