{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  makeWrapper,
  pkg-config,
  SDL2,
  dbus,
  libdecor,
  libnotify,
  dejavu_fonts,
  zenity,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "trigger-control";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "Etaash-mathamsetty";
    repo = "trigger-control";
    # upstream does not use consistant tags pattern, so we use git commit hash
    # https://github.com/Etaash-mathamsetty/trigger-control/tags
    rev = "7b46e743227830d3a97720067d0a6cf20133af90";
    hash = "sha256-nWSvsgksZ4Cxy1+i0xy8pNalgsiAuaqxNVwT/CThaBI=";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
  ];

  buildInputs =
    [
      SDL2
      dbus
      libnotify
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libdecor
    ];

  patches = [
    # Fix build on clang https://github.com/Etaash-mathamsetty/trigger-control/pull/23
    (fetchpatch {
      name = "clang.patch";
      url = "https://github.com/Etaash-mathamsetty/trigger-control/commit/bbec33296fdac7e2ca0398ae19ca8de8ad883407.patch";
      hash = "sha256-x6RymdzBlzAJ8O8QGqXQtvkZkjdTaC5X8syFPunqZik=";
    })
  ];

  # The app crashes without a changed fontdir and upstream recommends dejavu as font
  postPatch = ''
    substituteInPlace trigger-control.cpp --replace "/usr/share/fonts/" "${dejavu_fonts}/share/fonts/"
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

  meta = with lib; {
    description = "Control the dualsense's triggers on Linux (and Windows) with a gui and C++ api";
    homepage = "https://github.com/Etaash-mathamsetty/trigger-control";
    license = licenses.mit;
    mainProgram = "trigger-control";
    maintainers = with maintainers; [ azuwis ];
    platforms = platforms.all;
  };
})
