{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "tsidp";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tsidp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qOZJkCVAgR6xXZryysyFbf/P8zrLhe2iHYWFlIadiBM=";
  };

  vendorHash = "sha256-iBy+osK+2LdkTzXhrkSaB6nWpUCpr8VkxJTtcfVCFuw=";

  meta = {
    homepage = "https://github.com/tailscale/tsidp";
    changelog = "https://github.com/tailscale/tsidp/releases/tag/v${finalAttrs.version}";
    description = "Simple OIDC / OAuth Identity Provider (IdP) server for your tailnet";
    license = lib.licenses.bsd3;
    mainProgram = "tsidp";
    maintainers = with lib.maintainers; [ akotro ];
  };
})
