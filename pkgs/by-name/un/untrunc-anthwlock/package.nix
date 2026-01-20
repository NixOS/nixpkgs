{
  lib,
  stdenv,
  fetchFromGitHub,
  ffmpeg_6,
  libui,
  pkg-config,
  unstableGitUpdater,
  wrapGAppsHook3,
}:

stdenv.mkDerivation {
  pname = "untrunc-anthwlock";
  version = "0-unstable-2026-01-09";

  src = fetchFromGitHub {
    owner = "anthwlock";
    repo = "untrunc";
    rev = "8dc8ee2eb3ba5655906d6f462e8f5fc89fcbff97";
    hash = "sha256-WgzqHFryNbKbMusKVLYhOMCuAYDH1P9/l1K5PJi7E6U=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    # Uses ffmpeg internals; keep ffmpeg_6 until upstream supports newer API.
    # Upstream fix: https://github.com/anthwlock/untrunc/pull/249
    ffmpeg_6
    libui
  ];

  strictDeps = true;

  postPatch = ''
    substituteInPlace Makefile \
      --replace "-isystem/usr/include/ffmpeg" "\$(shell pkg-config --cflags libavformat libavcodec libavutil libui)" \
      --replace "-lavformat -lavcodec -lavutil" "\$(shell pkg-config --libs libavformat libavcodec libavutil)" \
      --replace "-lui -lpthread" "\$(shell pkg-config --libs libui) -lpthread"
  '';

  buildPhase = ''
    runHook preBuild
    make IS_RELEASE=1 untrunc
    make IS_RELEASE=1 untrunc-gui
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -D -t $out/bin untrunc untrunc-gui
    runHook postInstall
  '';

  enableParallelBuilding = true;

  passthru.updateScript = unstableGitUpdater {
    # Only stale "latest" tag
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Restore a truncated mp4/mov (improved version of ponchio/untrunc)";
    homepage = "https://github.com/anthwlock/untrunc";
    license = lib.licenses.gpl2Only;
    mainProgram = "untrunc";
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.romildo ];
  };
}
