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
    rev = "refs/tags/v${version}";
    hash = "sha256-gqgoG5JwGecm8MEqH36BvJyLuh6nDao1d9ydX1AlbgU=";
  };

  cargoHash = "sha256-LwJW1WTUa0iz4PeDOMmRr6H0XLhWOn9b4W3SUR+SHyc=";

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
