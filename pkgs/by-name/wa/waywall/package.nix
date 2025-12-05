{
  lib,
  stdenv,
  fetchFromGitHub,
  libGL,
  libspng,
  libxkbcommon,
  luajit,
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
  version = "0-unstable-2025-08-03";

  src = fetchFromGitHub {
    owner = "tesselslate";
    repo = "waywall";
    rev = "d77f51926a203b7ddfe095971e7c6c740dad0ffc";
    hash = "sha256-ev/A5ksqmWz6hpwUIoxg2k9BwzE4BNCZO4tpXq790zo=";
  };

  nativeBuildInputs = [
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
