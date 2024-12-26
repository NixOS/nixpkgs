{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "tombl";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "snyball";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XHvAgJ8/+ZkBxwZpMgaDchr0hBa1FXAd/j1+HH9N6qw=";
  };

  cargoHash = "sha256-w6LiKSH0koxtWxieyob9e+u5kRdbJOda2mtD4FQBxq0=";

  meta = {
    description = "Easily query TOML files from bash";
    homepage = "https://github.com/snyball/tombl";
    mainProgram = "tombl";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ oskardotglobal ];
  };
}
