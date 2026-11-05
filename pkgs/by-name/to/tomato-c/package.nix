{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  gnumake,
  libnotify,
  libpulseaudio,
  makeWrapper,
  ncurses,
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
    gnumake
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    libnotify
    libpulseaudio
    ncurses
  ];

  buildPhase = ''
    runHook preBuild
    make -C build PREFIX="$out" DATAPREFIX="$out/share/tomato"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 build/tomato "$out/bin/tomato"

    wrapProgram "$out/bin/tomato" \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          alsa-lib
          libpulseaudio
        ]
      }

    mkdir -p "$out/share/tomato/sprites" \
             "$out/share/tomato/sounds" \
             "$out/share/tomato/icons" \
             "$out/share/applications"

    install -m644 resources/sprites/*.asc        "$out/share/tomato/sprites/"
    install -m644 resources/sounds/*.mp3         "$out/share/tomato/sounds/"
    install -m644 resources/icons/tomato.png     "$out/share/tomato/icons/tomato.png"
    install -m644 resources/icons/tomato.svg     "$out/share/tomato/icons/tomato.svg"
    install -m644 sample_config.toml             "$out/share/tomato/sample_config.toml"

    install -m644 tomato.desktop "$out/share/applications/tomato.desktop"
    substituteInPlace "$out/share/applications/tomato.desktop" \
      --replace-fail "Icon=tomato" "Icon=$out/share/tomato/icons/tomato.svg"

    runHook postInstall
  '';

  strictDeps = true;

  meta = {
    description = "Modular, extensible terminal-based Pomodoro timer in pure C";
    homepage = "https://github.com/gabrielzschmitz/Tomato.C";
    changelog = "https://github.com/gabrielzschmitz/Tomato.C/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ gabrielzschmitz ];
    mainProgram = "tomato";
    platforms = lib.platforms.linux;
  };
})
