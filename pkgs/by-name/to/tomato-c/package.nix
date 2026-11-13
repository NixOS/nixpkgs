{
  lib,
  stdenv,
  fetchFromGitHub,
  libnotify,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  ncurses,
  alsa-lib,
  libpulseaudio,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tomato-c";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "gabrielzschmitz";
    repo = "Tomato.C";
    tag = "v${finalAttrs.version}";
    hash = "sha256-by6ed/lZ2XABCMxjWN/iTKIg3cUX5+B/3s2oe3tzo8I=";
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
    runHook preInstall

    install -Dm755 build/${finalAttrs.meta.mainProgram} $out/bin/${finalAttrs.meta.mainProgram}
    wrapProgram "$out/bin/tomato" \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          alsa-lib
          libpulseaudio
        ]
      }
    mkdir -p $out/share/tomato/{sprites,sounds,icons}
    cp resources/sprites/*.asc $out/share/tomato/sprites/
    cp resources/sounds/*.mp3 $out/share/tomato/sounds/
    cp resources/icons/* $out/share/tomato/icons/

    runHook postInstall
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
    changelog = "https://github.com/gabrielzschmitz/Tomato.C/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      _3JlOy-PYCCKUi
      gabrielzschmitz
    ];
    mainProgram = "tomato";
    platforms = lib.platforms.unix;
  };
})
