{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  version = "1.0.0";
in
buildGoModule {
  pname = "vault-unseal";
  inherit version;

  src = fetchFromGitHub {
    owner = "lrstanley";
    repo = "vault-unseal";
    rev = "v${version}";
    hash = "sha256-czfG7DsA6O2n8BlzEEvNtu0Dg277qBnLAdVUZLo6+8w=";
  };

  vendorHash = "sha256-ma3xbnWH87b1X5fdOjigzsj5gEfhbjyTLoIDyp9eY80=";

  meta = {
    changelog = "https://github.com/lrstanley/vault-unseal/releases/tag/v${version}";
    description = "Auto-unseal utility for Hashicorp Vault";
    homepage = "https://github.com/lrstanley/vault-unseal";
    license = lib.licenses.mit;
    mainProgram = "vault-unseal";
    maintainers = with lib.maintainers; [ mjm ];
  };
}
