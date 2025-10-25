{
  lib,
  stdenv,
  asciidoctor,
  fetchFromGitLab,
  makeWrapper,
  ncurses,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tetrix";
  version = "2.5";

  src = fetchFromGitLab {
    owner = "esr";
    repo = "tetrix";
    tag = finalAttrs.version;
    hash = "sha256-b9kp5STSYFFjVe/wyq5IeW+5JKOmAzAPGqq0cHIHotY=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "/usr/bin" "${placeholder "out"}/bin" \
      --replace-fail "/usr/share" "${placeholder "out"}/share"
  '';

  strictDeps = true;
  enableParallelBuilding = true;

  nativeBuildInputs = [
    asciidoctor
    makeWrapper
  ];
  buildInputs = [ ncurses ];

  env.NIX_CFLAGS_COMPILE = "-include ${./cuserid_compat.h}";

  buildFlags = [
    "tetrix"
    "tetrix.6"
  ];

  # Fix typo in man page name
  postBuild = ''
    if [ -e twtrix.6 ]; then
      mv twtrix.6 tetrix.6
    fi
  '';

  preInstall = ''
    mkdir -p $out/bin $out/share/man/man6
  '';

  # Store scores in the XDG state dir
  makeFlags = [ "SCORE_FILE=.TetScores" ];
  postInstall = ''
    mkdir $out/libexec
    mv $out/bin/tetrix $out/libexec/tetrix
    makeWrapper $out/libexec/tetrix $out/bin/tetrix --run \
      'set -e; state="''${XDG_STATE_HOME:-$HOME/.local/state}/tetrix"; mkdir -p "$state"; cd "$state"'
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Curses-based Tetris clone";
    homepage = "https://gitlab.com/esr/tetrix";
    changelog = "https://gitlab.com/esr/tetrix/-/blob/${finalAttrs.version}/NEWS.adoc";
    license = lib.licenses.bsd2;
    mainProgram = "tetrix";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ Zaczero ];
  };
})
