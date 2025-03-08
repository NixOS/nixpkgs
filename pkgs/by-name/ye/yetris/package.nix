{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yetris";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "alexdantas";
    repo = "yetris";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jhVircWMn+ZXoaX925O41ylpxmZxV9XAmIaANMWD6H4=";
  };

  buildInputs = [
    ncurses
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "BINDIR=$(EXEC_PREFIX)/bin"
  ];

  enableParallelBuilding = true;

  nativeCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Customizable Tetris(tm) for the terminal";
    homepage = "https://alexdantas.github.io/yetris/";
    downloadPage = "https://github.com/alexdantas/yetris";
    changelog = "https://github.com/alexdantas/yetris/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    mainProgram = "yetris";
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
})
