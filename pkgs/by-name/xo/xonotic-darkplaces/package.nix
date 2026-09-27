{
  lib,
  stdenv,
  fetchFromGitLab,
  d0-blind-id,
  gmp,
  libjpeg,
  zlib,
  libvorbis,
  libpng,
  libtheora,
  freetype,
  curl,
  SDL2,
  libx11,
  libGLU,
  libGL,
  libxpm,
  libxext,
  libxxf86vm,
  alsa-lib,
}:

let
  inherit (stdenv.hostPlatform) isLinux isDarwin;

  engines = {
    dedicated = "sv-release";
  }
  // lib.optionalAttrs (isLinux || isDarwin) {
    sdl = "sdl-release";
  }
  // lib.optionalAttrs isLinux {
    glx = "cl-release";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "xonotic-darkplaces";
  version = "0.8.6";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "xonotic";
    repo = "darkplaces";
    tag = "xonotic-v${finalAttrs.version}";
    hash = "sha256-rNG9scpgwE5T7iUvzfzMUYmqM0Os8CRkIe1X54JZSRw=";
  };

  patches = [ ./fix-build-with-c23.patch ];

  postPatch = lib.optionalString isDarwin ''
    substituteInPlace makefile.inc \
      --replace-fail 'LDFLAGS_BSDSDL=$(LDFLAGS_UNIXCOMMON) $(LDFLAGS_UNIXSDL)' \
        'LDFLAGS_BSDSDL=$(LDFLAGS_UNIXCOMMON) $(LDFLAGS_UNIXSDL) -framework IOKit -framework CoreFoundation'
  '';

  buildInputs = [
    d0-blind-id
    gmp
    libjpeg
    zlib
    libvorbis
    libpng
    libtheora
    freetype
    curl
    SDL2
    libx11
  ]
  ++ lib.optionals isLinux [
    libGLU
    libGL
    libxpm
    libxext
    libxxf86vm
    alsa-lib
  ];

  makeFlags = [
    # Set crypto flags as make variables so sub-makes inherit them.
    # DP_LINK_CRYPTO=foo avoids matching "shared"/"dlopen" conditionals.
    "DP_LINK_CRYPTO=foo"
    "CFLAGS_CRYPTO=-DLINK_TO_CRYPTO"
    "LIB_CRYPTO=-ld0_blind_id -lgmp"
    "DP_LINK_CRYPTO_RIJNDAEL=shared"
    "DP_PRELOAD_DEPENDENCIES=1"
    # ODE physics is unused by Xonotic; when left in dlopen mode the engine
    # resolves its symbols against itself and crashes.
    "DP_LINK_ODE=none"
  ];

  buildFlags = builtins.attrValues engines;

  # DP_MAKE_TARGET=bsd only fills in SDLCONFIG_CFLAGS/LIBS when DP_ARCH is
  # FreeBSD, so on Darwin the SDL2 include/link flags never get set by the
  # makefile itself; add them here instead of relying on sdl2-config, which
  # isn't on PATH during the build anyway.
  env = {
    NIX_CFLAGS_COMPILE = lib.concatStringsSep " " (
      [ "-I${lib.getDev d0-blind-id}/include" ]
      ++ lib.optional isDarwin "-I${lib.getDev SDL2}/include/SDL2"
    );
    NIX_LDFLAGS = lib.concatStringsSep " " (
      [ "-L${lib.getLib d0-blind-id}/lib" ]
      ++ lib.optionals isDarwin [
        "-L${lib.getLib SDL2}/lib"
        "-lSDL2"
      ]
    );
  }
  // lib.optionalAttrs isDarwin {
    DP_MAKE_TARGET = "bsd";
    DP_SOUND_API = "COREAUDIO";
  };

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 -t $out/bin ${
      lib.concatStringsSep " " (map (engine: "darkplaces-${engine}") (builtins.attrNames engines))
    }
    runHook postInstall
  '';

  meta = {
    description = "DarkPlaces engine built for Xonotic";
    homepage = "https://gitlab.com/xonotic/darkplaces";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      zalakain
      philocalyst
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "darkplaces-sdl";
  };
})
