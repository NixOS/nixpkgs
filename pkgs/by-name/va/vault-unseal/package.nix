{ lib
, buildGoModule
, fetchFromGitHub
}:

let
  version = "0.6.0";
in
buildGoModule {
  pname = "vault-unseal";
  inherit version;

  src = fetchFromGitHub {
    owner = "lrstanley";
    repo = "vault-unseal";
    rev = "v${version}";
    hash = "sha256-lryjinTzJNty2euvWP5rNyf7BZxlTD4x6zIEERF4vag=";
  };

  vendorHash = "sha256-vbVUIiFBmjH1ROKNBeV19NeHI1msqgJ1RonVh/Lp/CE=";

  meta = {
    changelog = "https://github.com/lrstanley/vault-unseal/releases/tag/v${version}";
    description = "Auto-unseal utility for Hashicorp Vault";
    homepage = "https://github.com/lrstanley/vault-unseal";
    license = lib.licenses.mit;
    mainProgram = "vault-unseal";
    maintainers = with lib.maintainers; [ mjm ];
  };
}
