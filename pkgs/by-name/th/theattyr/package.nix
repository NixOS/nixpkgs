{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "theattyr";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "theattyr";
    tag = "v${version}";
    hash = "sha256-gqgoG5JwGecm8MEqH36BvJyLuh6nDao1d9ydX1AlbgU=";
  };

  cargoHash = "sha256-44pHUqHBr0286Kc/yreb15mQXnFuyh12D2uCU2MrrTk=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal theater for playing VT100 art and animations";
    homepage = "https://github.com/orhun/theattyr";
    changelog = "https://github.com/orhun/theattyr/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ a-kenji ];
    mainProgram = "theattyr";
  };
}
