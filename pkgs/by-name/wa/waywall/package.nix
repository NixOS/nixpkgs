{
  lib,
  stdenv,
  fetchFromGitHub,
  libGL,
  libspng,
  libxkbcommon,
  luajit,
  makeWrapper,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libxcb,
  xwayland,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "waywall";
  version = "0.2026.01.11";

  src = fetchFromGitHub {
    owner = "tesselslate";
    repo = "waywall";
    tag = finalAttrs.version;
    hash = "sha256-VOtwVFMGgUvsGnD1CnflKtUy5tTKqK2C/qNsWwgbyEU=";
  };

  nativeBuildInputs = [
    makeWrapper
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    libGL
    libspng
    libxkbcommon
    luajit
    wayland
    wayland-protocols
    libxcb
    xwayland
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 waywall/waywall -t $out/bin

    wrapProgram $out/bin/waywall \
      --prefix PATH : ${lib.makeBinPath [ xwayland ]}

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wayland compositor for Minecraft speedrunning";
    longDescription = ''
      Waywall is a Wayland compositor that provides various convenient
      features (key rebinding, Ninjabrain Bot support, etc) for Minecraft
      speedrunning. It is designed to be nested within an existing Wayland
      session and is intended as a successor to resetti.
    '';
    homepage = "https://tesselslate.github.io/waywall/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      monkieeboi
      uku3lig
    ];
    platforms = lib.platforms.linux;
    mainProgram = "waywall";
  };
})
