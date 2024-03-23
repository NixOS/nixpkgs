{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, meson
, ninja
, pkg-config
, wrapGAppsHook
, gtk3
, libXtst
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xclicker";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "robiot";
    repo = "xclicker";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3D49iMzCCT9Z2Pf5INHYFZusG0BQI7La7lLaSVM/4mc=";
  };

  patches = [
    (fetchpatch {
      name = "fix-malloc-size.patch";
      url = "https://github.com/robiot/xclicker/commit/c99f69a747e9df75fb3676be20a3ec805526d022.patch";
      hash = "sha256-ESbMBusJVNfbGxlEn1Kby00mnXvM5H0r03bX5ofC6Fg=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook
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
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux;
  };
})
