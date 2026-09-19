{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ffmpeg,
  networkmanager,
  SDL2,
  SDL2_ttf,
  SDL2_image,
  openssl,
  pkg-config,
  glib,
  libnl,
  git,
  libwebp,
  libtiff,
  polkit,
  libxml2,
  libx11,
  autoAddDriverRunpath,
  unstableGitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vanilla-wiiu";
  version = "0-unstable-2026-09-13";
  __structuredAttrs = true;
  strictDeps = true;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "vanilla-wiiu";
    repo = "vanilla";
    rev = "7151067c1f395ac25b92c4bc60a6c0d31f5847fd";
    hash = "sha256-ft1EAJLuY5BGXl6PQuD18kS7Tjmessmmqpq7jbgJ+GQ=";
    fetchSubmodules = true;
  };

  drc-hostap-src = fetchFromGitHub {
    owner = "vanilla-wiiu";
    repo = "drc-hostap";
    rev = "257096accc39f9c2750a7718ff5751108d15f668";
    hash = "sha256-W6oSFMym9vOK6Q7EQA0yyGuCqJmSNKD0Ff21lLSWkAg=";
  };

  patches = [ ./hostap-nix-source.patch ];

  postPatch = ''
    substituteInPlace pipe/linux/CMakeLists.txt \
      --replace-fail '@DRC_HOSTAP_SRC@' '${finalAttrs.drc-hostap-src}'

    substituteInPlace gui/ui/ui_sdl.c \
      --replace-fail '<SDL_image.h>' '<SDL2/SDL_image.h>' \
      --replace-fail '<SDL_ttf.h>' '<SDL2/SDL_ttf.h>'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    git
  ];

  buildInputs = [
    ffmpeg
    networkmanager
    libnl
    glib
    SDL2
    SDL2_ttf
    SDL2_image
    openssl
    libwebp
    libtiff
    polkit
    libxml2
    libx11
    autoAddDriverRunpath
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  postInstall = ''
    # namespace to match pname
    mv "$out/bin/vanilla" "$out/bin/vanilla-wiiu"
    mv "$out/bin/vanilla-pipe" "$out/bin/vanilla-wiiu-pipe"
    substituteInPlace "$out/share/applications/com.mattkc.vanilla.desktop" \
      --replace-fail "Exec=vanilla" "Exec=vanilla-wiiu"

    # unsure whether these are dev artifacts or genuine required libraries. As far as I can tell, they're dev artifacts
    moveToOutput "lib/*.a" "$dev"
  '';

  # should be able to handle occasional updates at this time
  passthru.updateScript = unstableGitUpdater {
    branch = "master";
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "";
    homepage = "https://github.com/vanilla-wiiu/vanilla";
    changelog = "https://github.com/vanilla-wiiu/vanilla/releases/tag/continuous";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ mistyttm ];
    mainProgram = "vanilla-wiiu";
    platforms = lib.platforms.all;
  };
})
