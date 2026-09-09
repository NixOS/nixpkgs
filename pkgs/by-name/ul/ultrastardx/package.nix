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
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libx11
    libGLU
    libGL
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ultrastardx";
  version = "2026.8.1";

  src = fetchFromGitHub {
    owner = "UltraStar-Deluxe";
    repo = "USDX";
    rev = "v${finalAttrs.version}";
    hash = "sha256-z6gEjXZwq4jSUEjhECo4E5AI3bMETilmvYzTW6OXN2M=";
  };

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
  // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    MACOSX_DEPLOYMENT_TARGET = "10.13";
  };

  # fpc's fpc.cfg hardcodes -FD/Applications/Xcode.app/.../usr/bin to find `as`/`ld`,
  # which is unreachable in the build sandbox and has no sysroot.
  preBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export PFLAGS_EXTRA="-FD${lib.getBin stdenv.cc.bintools}/bin -XR$SDKROOT $PFLAGS_EXTRA"
  '';

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    make macos-app
    mkdir -p "$out/Applications" "$out/bin"
    cp -R UltraStarDeluxe.app "$out/Applications/"
    ln -s "$out/Applications/UltraStarDeluxe.app/Contents/MacOS/ultrastardx" \
          "$out/bin/ultrastardx"
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
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
