{
  lib,
  stdenv,
  fetchurl,
  ncurses,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "znake";
  version = "1.18";

  src = fetchurl {
    url = "https://downloads.sourceforge.net/project/znake-ulven/znake-${finalAttrs.version}/znake-${finalAttrs.version}.tar.gz";
    hash = "sha256-XgFzn8R7vBwtz13169Iu3UZxGZf9XH92Cvm4Bldyr1w=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  buildInputs = [ ncurses ];

  # Fix multiple definition errors with GCC 10+
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  postPatch = ''
    substituteInPlace src/Makefile \
      --replace-fail "CC=gcc" "CC=$CC" \
      --replace-fail "CFLAGS=-Wall -lncurses" "CFLAGS+=-Wall -lncurses"

    substituteInPlace src/main.c \
      --replace-fail "int r;" "int r = TRUE;"
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 src/znake $out/bin/znake

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Simple colorful clone of the famous game Snake";
    homepage = "https://sourceforge.net/projects/znake-ulven/";
    mainProgram = "znake";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
