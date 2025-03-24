{
  lib,
  stdenv,
  fetchurl,
  SDL,
  SDL_ttf,
  jack2,
  libmpg123,
  ffmpeg,
  cdparanoia,
  dejavu_fonts,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xwax";
  version = "1.9";

  src = fetchurl {
    url = "https://xwax.org/releases/xwax-${finalAttrs.version}.tar.gz";
    hash = "sha256-m+2PoUMYKBhlA2H0kld1W/iR8UMWEGaqp7yoxszp9jI=";
  };

  postPatch = ''
    # When cross-compiling sdl-config will not be available in $PATH,
    # so we must provide the full path.
    substituteInPlace Makefile \
      --replace-fail sdl-config "${lib.getExe' (lib.getDev SDL) "sdl-config"}"

    # font loading in xwax is relying on a hardcoded list of paths,
    # therefore we patch interface.c to also look up in the dejavu_fonts nix store path
    substituteInPlace interface.c \
      --replace-fail "/usr/X11R6/lib/X11/fonts/TTF" "${dejavu_fonts.outPath}/share/fonts/truetype/"
  '';

  buildInputs = [
    # sdl
    SDL
    SDL_ttf

    # audio server
    jack2

    # audio decoder
    libmpg123
    ffmpeg
    cdparanoia

    # fonts
    dejavu_fonts
  ];

  configureFlags = [
    "--enable-alsa"
    "--enable-jack"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-h";
  doInstallCheck = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp xwax  $out/bin/xwax
    runHook postInstall
  '';

  meta = {
    homepage = "https://xwax.org";
    description = "Digital vinyl on Linux";
    mainProgram = "xwax";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ obsoleszenz ];
    platforms = lib.platforms.linux;
  };
})
