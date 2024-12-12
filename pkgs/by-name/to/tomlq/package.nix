{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "tomlq";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "cryptaliagy";
    repo = "tomlq";
    rev = "refs/tags/${version}";
    hash = "sha256-g8xjz8qCTiulTwcEbLTHYldw4PI+4ZfCOMJs+J6L1C4=";
  };

  cargoHash = "sha256-/cepTVJoBM1LYZkFpH9UCvE74cSszHDaeThsZksQ1P8=";

  meta = {
    description = "Tool for getting data from TOML files on the command line";
    homepage = "https://github.com/cryptaliagy/tomlq";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kinzoku ];
    mainProgram = "tq";
  };
}
