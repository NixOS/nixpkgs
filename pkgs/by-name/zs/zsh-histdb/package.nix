{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  zsh,
  sqlite,
}:

stdenvNoCC.mkDerivation {
  pname = "zsh-histdb";
  version = "0-unstable-2026-09-18";

  src = fetchFromGitHub {
    owner = "larkery";
    repo = "zsh-histdb";
    rev = "27b719a993414321135ddaf73f9a4ecf785bd8c5";
    hash = "sha256-w1HsIkhsB6iG6yFBpiNcyXPiuPprkoQ49wO1jfWRExs=";
  };

  postPatch = ''
    substituteInPlace sqlite-history.zsh \
      --replace-fail 'sqlite3' '"${lib.getExe sqlite}"'
  '';

  buildInputs = [
    zsh
  ];

  installPhase = ''
    runHook preInstall

    install -Dt $out/share/zsh-histdb/ \
      sqlite-history.zsh histdb-fzf.zsh histdb-interactive.zsh histdb-{merge,migrate}

    runHook postInstall
  '';

  meta = {
    description = "History database for Zsh, based on SQLite";
    homepage = "https://github.com/larkery/zsh-histdb";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fliegendewurst
      luochen1990
    ];
    platforms = lib.platforms.unix;
  };
}
