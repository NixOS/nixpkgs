{ lib
, buildGoModule
, fetchFromGitHub
}:

let
  version = "0.5.1";
in
buildGoModule {
  pname = "vault-unseal";
  inherit version;

  src = fetchFromGitHub {
    owner = "lrstanley";
    repo = "vault-unseal";
    rev = "v${version}";
    hash = "sha256-vjU4080uCId/73F7CJKDtk9b1siCPIZOaSczKMNf0LE=";
  };

  vendorHash = "sha256-SEA74Tk0R3BHyLMZEgKatfLGbX7l8Zyn/JkQVfEckI4=";

  meta = {
    changelog = "https://github.com/lrstanley/vault-unseal/releases/tag/v${version}";
    description = "Auto-unseal utility for Hashicorp Vault";
    homepage = "https://github.com/lrstanley/vault-unseal";
    license = lib.licenses.mit;
    mainProgram = "vault-unseal";
    maintainers = with lib.maintainers; [ mjm ];
  };
}
