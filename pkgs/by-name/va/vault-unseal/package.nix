{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  version = "1.0.3";
in
buildGoModule {
  pname = "vault-unseal";
  inherit version;

  src = fetchFromGitHub {
    owner = "lrstanley";
    repo = "vault-unseal";
    rev = "v${version}";
    hash = "sha256-MJUruxpxkLmSfZJKWExnBduQ6sZOF4LfG1i5S3Suk2A=";
  };

  vendorHash = "sha256-8b98JeDSfK2cDGnPo0isglO/fCZpYU73uxSYldq6lbc=";

  meta = {
    changelog = "https://github.com/lrstanley/vault-unseal/releases/tag/v${version}";
    description = "Auto-unseal utility for Hashicorp Vault";
    homepage = "https://github.com/lrstanley/vault-unseal";
    license = lib.licenses.mit;
    mainProgram = "vault-unseal";
    maintainers = with lib.maintainers; [ mjm ];
  };
}
