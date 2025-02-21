{
  lib,
  stdenv,
  fetchFromGitHub,
  egl-wayland,
  libspng,
  libxkbcommon,
  luajit,
  mesa_glu,
  meson,
  ninja,
  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,
  xorg,
  xwayland,
}:
stdenv.mkDerivation {
  pname = "waywall";
  version = "0-unstable-2025-02-07";

  src = fetchFromGitHub {
    owner = "tesselslate";
    repo = "waywall";
    rev = "be96e20997c5886af9661d9832b7902aba1e5311";
    hash = "sha256-77GbBzHjyZuauhl0vlguUS/7jBT4qNjOLYGWBVTPjEY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-protocols
    wayland-scanner
  ];

  buildInputs = [
    egl-wayland
    libspng
    libxkbcommon
    luajit
    mesa_glu
    wayland
    xorg.libxcb
    xwayland
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 waywall/waywall -t $out/bin

    runHook postInstall
  '';

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
    ];
    platforms = lib.platforms.linux;
    mainProgram = "waywall";
  };
}
