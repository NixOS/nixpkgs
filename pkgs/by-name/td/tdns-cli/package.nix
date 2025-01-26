{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "tdns-cli";
  version = "unstable-2021-02-19";

  src = fetchFromGitHub {
    owner = "rotty";
    repo = pname;
    rev = "9a5455fe8a52f3f14dc55ef81511b479c8cd70ea";
    hash = "sha256-BGxkqlKg81izq4eOBEZFJ/MPb3UCSOo8ZTYTjtjierk=";
  };

  cargoHash = "sha256-uRny+l/LaQPjF5AnbxgKFLdjuAxcez1BqsL4g54KAwU=";

  meta = with lib; {
    description = "DNS tool that aims to replace dig and nsupdate";
    homepage = "https://github.com/rotty/tdns-cli";
    license = licenses.gpl3;
    maintainers = with maintainers; [ astro ];
    mainProgram = "tdns";
  };
}
