{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  glew,
  makeWrapper,
  pkg-config,
  sdl_gamecontrollerdb,
  SDL2,
  writeShellApplication,
}:

let
  datadir = "\"\${XDG_DATA_HOME:-$HOME/.local/share}\"/wipeout-rewrite";
  datadirCheck = writeShellApplication {
    name = "wipeout-rewrite-check-datadir";
    text = ''
      datadir=${datadir}

      if [ ! -d "$datadir" ]; then
        echo "[Wrapper] Creating data directory $datadir"
        mkdir -p "$datadir"
      fi

      echo "[Wrapper] Remember to put your game assets into $datadir/wipeout if you haven't done so yet!"
      echo "[Wrapper] Check https://github.com/phoboslab/wipeout-rewrite#running for the required format."
    '';
  };

  # Would be cool if this was a passthru attribute of sdl_gamecontrollerdb?
  gameControllerDbPath = "${sdl_gamecontrollerdb}/share/gamecontrollerdb.txt";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "wipeout-rewrite";
  version = "0-unstable-2026-08-09";

  src = fetchFromGitHub {
    owner = "phoboslab";
    repo = "wipeout-rewrite";
    rev = "d48f01c8f00e7f4820a9c2ead0dedd4fb33427d3";
    hash = "sha256-X14rixCUJCQYxeLRpnSb3xWslwcwxoyLtYu1YH3O7WY=";
  };

  postPatch =
    # Don't rely on sdl2-config (gives issues with strictDeps & cross)
    ''
      substituteInPlace Makefile \
        --replace-fail 'sdl2-config' "$PKG_CONFIG sdl2"
    ''
    # Hardcode path to our sdl_gamecontrollerdb (with a check to make sure it actually exists)
    + ''
      if [ ! -f ${gameControllerDbPath} ]; then
        echo "${gameControllerDbPath} does not exist!"
        exit 1
      fi

      substituteInPlace src/platform_sdl.c \
        --replace-fail \
          'char *gcdb_path = strcat(strcpy(temp_path, path_assets), "gamecontrollerdb.txt")' \
          'char *gcdb_path = "${gameControllerDbPath}"'
    '';

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    glew
    SDL2
  ];

  enableParallelBuilding = true;

  # Force this to empty, so assets are looked up in CWD instead of $out/bin
  env.NIX_CFLAGS_COMPILE = "-DPATH_ASSETS=";

  installPhase = ''
    runHook preInstall

    install -Dm755 wipegame $out/bin/wipegame
  ''
  # I can't get --chdir to not expand the bash variables in datadir at build time (so they point to /homeless-shelter)
  # or put them inside single quotes (breaking the expansion at runtime)
  + ''
    wrapProgram $out/bin/wipegame \
      --run '${lib.getExe datadirCheck}' \
      --run 'cd ${datadir}'

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    mainProgram = "wipegame";
    description = "Re-implementation of the 1995 PSX game wipEout";
    homepage = "https://github.com/phoboslab/wipeout-rewrite";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.all;
  };
})
