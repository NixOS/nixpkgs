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
  version = "0-unstable-2024-04-18";

  src = fetchFromGitHub {
    owner = "larkery";
    repo = "zsh-histdb";
    rev = "90a6c104d0fcc0410d665e148fa7da28c49684eb";
    hash = "sha256-vtG1poaRVbfb/wKPChk1WpPgDq+7udLqLfYfLqap4Vg=";
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
      sqlite-history.zsh histdb-interactive.zsh histdb-{merge,migrate}

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
