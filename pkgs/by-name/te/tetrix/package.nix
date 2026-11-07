{
  lib,
  stdenv,
  asciidoctor,
  fetchFromGitLab,
  makeWrapper,
  ncurses,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "tetrix";
  version = "2.5-unstable-2025-11-23";

  src = fetchFromGitLab {
    owner = "esr";
    repo = "tetrix";
    rev = "01f3d8634ad59bc32eb18e21f778ac9b111a8590";
    hash = "sha256-IGXqi3AqUHPI6xLaD4CpYOqp4r6Uk0aE/UyZ0/yEw0Q=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "/usr/bin" "${placeholder "out"}/libexec" \
      --replace-fail "/usr/share" "${placeholder "out"}/share"
  '';

  strictDeps = true;
  enableParallelBuilding = true;

  nativeBuildInputs = [
    asciidoctor
    makeWrapper
  ];
  buildInputs = [ ncurses ];

  buildFlags = [
    "tetrix"
    "tetrix.6"
  ];

  preInstall = ''
    mkdir -p $out/bin $out/libexec $out/share/man/man6
  '';

  # Store scores in the XDG state dir
  makeFlags = [ "SCORE_FILE=.TetScores" ];
  postInstall = ''
    makeWrapper $out/libexec/tetrix $out/bin/tetrix --run \
      'set -e; state="''${XDG_STATE_HOME:-$HOME/.local/state}/tetrix"; mkdir -p "$state"; cd "$state"'
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Curses-based Tetris clone";
    homepage = "https://gitlab.com/esr/tetrix";
    changelog = "https://gitlab.com/esr/tetrix/-/blob/master/NEWS.adoc";
    license = lib.licenses.bsd2;
    mainProgram = "tetrix";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ Zaczero ];
  };
}
