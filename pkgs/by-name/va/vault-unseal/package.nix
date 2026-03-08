{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  version = "0.7.2";
in
buildGoModule {
  pname = "vault-unseal";
  inherit version;

  src = fetchFromGitHub {
    owner = "lrstanley";
    repo = "vault-unseal";
    rev = "v${version}";
    hash = "sha256-xv33wx/JjvpL9ryyWeZde+a6UPWqYXQcsAxOzmHFAyo=";
  };

  vendorHash = "sha256-hhTJB1g35vB5dLOEY7V7V5ma7Zzyq2bo9kk3gpEcEsY=";

  meta = {
    changelog = "https://github.com/lrstanley/vault-unseal/releases/tag/v${version}";
    description = "Auto-unseal utility for Hashicorp Vault";
    homepage = "https://github.com/lrstanley/vault-unseal";
    license = lib.licenses.mit;
    mainProgram = "vault-unseal";
    maintainers = with lib.maintainers; [ mjm ];
  };
}
