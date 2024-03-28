{ lib, stdenvNoCC, fetchFromGitHub, makeWrapper, zsh, sqlite }:

stdenvNoCC.mkDerivation {
  pname = "zsh-histdb";
  version = "unstable-2022-01-18";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "larkery";
    repo = "zsh-histdb";
    rev = "30797f0c50c31c8d8de32386970c5d480e5ab35d";
    hash = "sha256-PQIFF8kz+baqmZWiSr+wc4EleZ/KD8Y+lxW2NT35/bg=";
  };

  installPhase = let
    deps_path = lib.makeBinPath [
      zsh
      sqlite
    ];
  in ''
    runHook preInstall

    install -Dt $out/share/zsh-histdb/ sqlite-history.zsh histdb-interactive.zsh
    wrapProgram $out/share/zsh-histdb/sqlite-history.zsh --set PATH ${deps_path}
    wrapProgram $out/share/zsh-histdb/histdb-interactive.zsh --set PATH ${deps_path}

    runHook postInstall
  '';

  meta = with lib; {
    description = "A slightly better history for zsh";
    homepage = "https://github.com/larkery/zsh-histdb";
    license = licenses.mit;
    maintainers = with maintainers; [ luochen1990 ];
  };
}
