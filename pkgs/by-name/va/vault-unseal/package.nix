{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  version = "0.7.0";
in
buildGoModule {
  pname = "vault-unseal";
  inherit version;

  src = fetchFromGitHub {
    owner = "lrstanley";
    repo = "vault-unseal";
    rev = "v${version}";
    hash = "sha256-+9o2+6PwRZjCaJnr2sriTk74cWZXURMndusakd4Vd8g=";
  };

  vendorHash = "sha256-UDYybx9oA9iKkfs6ELDEFhMq3WBrwWXbxSHQyS7E3Cs=";

  meta = {
    changelog = "https://github.com/lrstanley/vault-unseal/releases/tag/v${version}";
    description = "Auto-unseal utility for Hashicorp Vault";
    homepage = "https://github.com/lrstanley/vault-unseal";
    license = lib.licenses.mit;
    mainProgram = "vault-unseal";
    maintainers = with lib.maintainers; [ mjm ];
  };
}
