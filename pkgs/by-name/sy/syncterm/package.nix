{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  perl,
  unzip,
  autoPatchelfHook,
  ncurses,
  SDL2,
  libx11,
  alsa-lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "syncterm";
  version = "1.6";

  src = fetchurl {
    url = "mirror://sourceforge/syncterm/syncterm-${finalAttrs.version}-src.tgz";
    hash = "sha256-eeOuQ9OfmKWSJo/0AJQJTaYqpYe1uSXmt0WdZqXRHUk=";
  };

  # We can't use sourceRoot, as the cherry-picked patches apply to files outside of it.
  postPatch = "cd src/syncterm";

  CFLAGS = [
    "-DHAS_INTTYPES_H"
    "-DXPDEV_DONT_DEFINE_INTTYPES"

    "-Wno-unused-result"
    "-Wformat-overflow=0"
  ]
  ++ (lib.optionals stdenv.hostPlatform.isLinux [
    "-DUSE_ALSA_SOUND" # Don't use OSS for beeps.
  ]);

  makeFlags = [
    "PREFIX=$(out)"
    "RELEASE=1"
    "USE_SDL_AUDIO=1"
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    pkg-config
    SDL2
    libx11
    perl
    unzip
  ]; # SDL2 for `sdl2-config`.
  buildInputs = [
    ncurses
    SDL2
  ]
  ++ (lib.optional stdenv.hostPlatform.isLinux alsa-lib);
  runtimeDependencies = [
    ncurses
    SDL2
  ]; # Both of these are dlopen()'ed at runtime.

  meta = {
    # error: unsupported option '-fsanitize=safe-stack' for target 'x86_64-apple-darwin'
    broken =
      (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) || stdenv.hostPlatform.isDarwin;
    homepage = "https://syncterm.bbsdev.net/";
    description = "BBS terminal emulator";
    mainProgram = "syncterm";
    maintainers = with lib.maintainers; [ embr ];
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
  };
})
