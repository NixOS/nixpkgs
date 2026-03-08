{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "tsidp";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tsidp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-quhMj015EfchFeJIl/t1Z+zman/6IAYsRumCcN2wkAw=";
  };

  vendorHash = "sha256-iBy+osK+2LdkTzXhrkSaB6nWpUCpr8VkxJTtcfVCFuw=";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/tailscale/tsidp";
    changelog = "https://github.com/tailscale/tsidp/releases/tag/v${finalAttrs.version}";
    description = "Simple OIDC / OAuth Identity Provider (IdP) server for your tailnet";
    license = lib.licenses.bsd3;
    mainProgram = "tsidp";
    maintainers = with lib.maintainers; [ akotro ];
  };
})
