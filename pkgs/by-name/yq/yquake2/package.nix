{
  lib,
  stdenv,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  SDL2,
  libGL,
  curl,
  openalSupport ? true,
  openal,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yquake2";
  version = "8.60";

  src = fetchFromGitHub {
    owner = "yquake2";
    repo = "yquake2";
    tag = "QUAKE2_${builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-XD0Fnx3TZwZUvjLOpzM5oWoIQFykDuBOddQXudkiyB0=";
  };

  postPatch = ''
    substituteInPlace src/client/curl/qcurl.c \
      --replace "\"libcurl.so.3\", \"libcurl.so.4\"" "\"${curl.out}/lib/libcurl.so\", \"libcurl.so.3\", \"libcurl.so.4\""
  ''
  + lib.optionalString (openalSupport && !stdenv.hostPlatform.isDarwin) ''
    substituteInPlace Makefile \
      --replace "\"libopenal.so.1\"" "\"${openal}/lib/libopenal.so.1\""
  '';

  buildInputs = [
    SDL2
    libGL
    curl
  ]
  ++ lib.optional openalSupport openal;

  makeFlags = [
    "WITH_OPENAL=${lib.boolToYesNo openalSupport}"
    "WITH_SYSTEMWIDE=yes"
    "WITH_SYSTEMDIR=\${out}/share/games/quake2"
  ];

  nativeBuildInputs = [ copyDesktopItems ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    # Yamagi Quake II expects all binaries (executables and libs) to be in the
    # same directory.
    mkdir -p $out/bin $out/lib/yquake2 $out/share/games/quake2/baseq2
    cp -r release/* $out/lib/yquake2
    ln -s $out/lib/yquake2/quake2 $out/bin/yquake2
    ln -s $out/lib/yquake2/q2ded $out/bin/yq2ded
    cp $src/stuff/yq2.cfg $out/share/games/quake2/baseq2
    install -Dm644 stuff/icon/Quake2.png $out/share/icons/hicolor/512x512/apps/yamagi-quake2.png;
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "yquake2";
      exec = "yquake2";
      icon = "yamagi-quake2";
      desktopName = "yquake2";
      comment = "Yamagi Quake II client";
      categories = [
        "Game"
        "Shooter"
      ];
    })
  ];

  meta = {
    description = "Yamagi Quake II client";
    homepage = "https://www.yamagi.org/quake2/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ tadfisher ];
  };
})
