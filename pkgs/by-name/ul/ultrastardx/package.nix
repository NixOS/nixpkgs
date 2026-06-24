{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  pkg-config,
  lua,
  fpc,
  portaudio,
  freetype,
  libpng,
  SDL2,
  SDL2_image,
  SDL2_gfx,
  SDL2_mixer,
  SDL2_net,
  SDL2_ttf,
  ffmpeg,
  sqlite,
  fetchpatch,
  zlib,
  libx11,
  libGLU,
  libGL,
}:

let
  sharedLibs = [
    portaudio
    freetype
    SDL2
    SDL2_image
    SDL2_gfx
    SDL2_mixer
    SDL2_net
    SDL2_ttf
    sqlite
    lua
    zlib
    ffmpeg
  ]
  ++ lib.optionals stdenv.isLinux [
    libx11
    libGLU
    libGL
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ultrastardx";
  version = "2026.6.0";

  src = fetchFromGitHub {
    owner = "UltraStar-Deluxe";
    repo = "USDX";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xqP50OFUT+wreG/EZhmh5zPOwpNvG1TQkLzovgVDquI=";
  };

  patches = [
    # FPC 3.2.4 Darwin: USkins.pas <-> UIni.pas form a circular implementation-uses dependency
    (fetchpatch {
      url = "https://github.com/UltraStar-Deluxe/USDX/commit/7b3be9b7a64bd7274eb562ebcdcd8aa83a8db188.patch";
      hash = "sha256-xCTE01c1RhA35rex4AH5BTpLFHD8KN8XpBbb09aXwFA=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    fpc
    libpng
  ]
  ++ sharedLibs;

  env = {
    NIX_LDFLAGS = lib.concatMapStringsSep " " (x: "-rpath ${lib.getLib x}/lib") sharedLibs;
  }
  // lib.optionalAttrs stdenv.isDarwin {
    MACOSX_DEPLOYMENT_TARGET = "10.13";
  };

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.isDarwin ''
    make macos-app
    mkdir -p "$out/Applications" "$out/bin"
    cp -R UltraStarDeluxe.app "$out/Applications/"
    ln -s "$out/Applications/UltraStarDeluxe.app/Contents/MacOS/ultrastardx" \
          "$out/bin/ultrastardx"
  ''
  + lib.optionalString stdenv.isLinux ''
    make install
    install -Dm644 dists/ultrastardx.desktop \
      "$out/share/applications/ultrastardx.desktop"
  ''
  + ''
    runHook postInstall
  '';

  # dlopened libgcc requires the rpath not to be shrunk
  dontPatchELF = true;

  meta = {
    homepage = "https://usdx.eu/";
    description = "Free and open source karaoke game";
    mainProgram = "ultrastardx";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      diogotcorreia
      philocalyst
    ];
    platforms = with lib.platforms; linux ++ darwin ++ windows;
  };
})
