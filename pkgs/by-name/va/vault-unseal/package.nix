{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  version = "1.0.1";
in
buildGoModule {
  pname = "vault-unseal";
  inherit version;

  src = fetchFromGitHub {
    owner = "lrstanley";
    repo = "vault-unseal";
    rev = "v${version}";
    hash = "sha256-AVKQbX5xFCU9aNdDm2uTr+v2w4vnVEhTd3jfgqwXN2E=";
  };

  vendorHash = "sha256-/ov2rvVZJgRsALgBMTaQE4CXplBJDhBrlIq2rHblO4k=";

  meta = {
    changelog = "https://github.com/lrstanley/vault-unseal/releases/tag/v${version}";
    description = "Auto-unseal utility for Hashicorp Vault";
    homepage = "https://github.com/lrstanley/vault-unseal";
    license = lib.licenses.mit;
    mainProgram = "vault-unseal";
    maintainers = with lib.maintainers; [ mjm ];
  };
}
