{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wrapGAppsHook3
, gtk3
, libXtst
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xclicker";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "robiot";
    repo = "xclicker";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zVbOfqh21+/41N3FcAFajcZCrQ8iNqedZjgNQO0Zj04=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libXtst
  ];

  mesonBuildType = "release";

  installPhase = ''
    runHook preInstall
    install -Dm755 ./src/xclicker $out/bin/xclicker
    install -Dm644 $src/assets/xclicker.desktop $out/share/applications/xclicker.desktop
    install -Dm644 $src/assets/icon.png $out/share/pixmaps/xclicker.png
    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/robiot/xclicker/releases/tag/${finalAttrs.src.rev}";
    description = "Fast gui autoclicker for x11 linux desktops";
    homepage = "https://xclicker.xyz/";
    license = lib.licenses.gpl3Only;
    mainProgram = "xclicker";
    maintainers = with lib.maintainers; [ gepbird tomasajt ];
    platforms = lib.platforms.linux;
  };
})
