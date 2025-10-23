{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  makeWrapper,
  pkg-config,
  SDL2,
  libX11,
  dbus,
  libdecor,
  libnotify,
  zenity,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "trigger-control";
  version = "1.5.1-unstable-2024-12-16";

  src = fetchFromGitHub {
    owner = "Etaash-mathamsetty";
    repo = "trigger-control";
    rev = "ed9b6f994b050e8890cb73e7d2997723fdd0ca2c";
    hash = "sha256-pwI6hHae3yJpUx3v4yVLUW2t4LKQcWqiMPM9Q9NjY3Q=";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    SDL2
    libX11
    dbus
    libnotify
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libdecor
  ];

  # cmake 4 compatibility
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail "cmake_minimum_required(VERSION 3.0)" "cmake_minimum_required(VERSION 3.10)"
  '';

  installPhase = ''
    runHook preInstall

    install -D trigger-control $out/bin/trigger-control

    runHook postInstall
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/trigger-control \
      --prefix PATH : ${lib.makeBinPath [ zenity ]}
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version=branch"
      "--version-regex=[^0-9]*([0-9][0-9.]*-unstable-.*)"
    ];
  };

  meta = with lib; {
    description = "Control the dualsense's triggers on Linux (and Windows) with a gui and C++ api";
    homepage = "https://github.com/Etaash-mathamsetty/trigger-control";
    license = licenses.mit;
    mainProgram = "trigger-control";
    maintainers = with maintainers; [ azuwis ];
    platforms = platforms.all;
  };
})
