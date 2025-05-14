{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  makeWrapper,
  glew,
  SDL2,
  writeShellScript,
}:

let
  datadir = "\"\${XDG_DATA_HOME:-$HOME/.local/share}\"/wipeout-rewrite";
  datadirCheck = writeShellScript "wipeout-rewrite-check-datadir.sh" ''
    datadir=${datadir}

    if [ ! -d "$datadir" ]; then
      echo "[Wrapper] Creating data directory $datadir"
      mkdir -p "$datadir"
    fi

    echo "[Wrapper] Remember to put your game assets into $datadir/wipeout if you haven't done so yet!"
    echo "[Wrapper] Check https://github.com/phoboslab/wipeout-rewrite#running for the required format."
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "wipeout-rewrite";
  version = "0-unstable-2025-04-26";

  src = fetchFromGitHub {
    owner = "phoboslab";
    repo = "wipeout-rewrite";
    rev = "38159b447c53fe9d0e3a02c82f2c20eb21138afb";
    hash = "sha256-dB90khtdj2386SYiHxE3OYt8iJjy640/4VRXGjqh1ww=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    glew
    SDL2
  ];

  # Force this to empty, so assets are looked up in CWD instead of $out/bin
  env.NIX_CFLAGS_COMPILE = "-DPATH_ASSETS=";

  installPhase = ''
    runHook preInstall

    install -Dm755 wipegame $out/bin/wipegame

    # I can't get --chdir to not expand the bash variables in datadir at build time (so they point to /homeless-shelter)
    # or put them inside single quotes (breaking the expansion at runtime)
    wrapProgram $out/bin/wipegame \
      --run '${datadirCheck}' \
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
