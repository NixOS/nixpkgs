{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "tsidp";
<<<<<<< HEAD
  version = "0.0.9";
=======
  version = "0.0.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tsidp";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-ClN3aZ0mLmb4UPSW+oQSrKPar56wbHp+NXOzGA6GpCQ=";
=======
    hash = "sha256-qOZJkCVAgR6xXZryysyFbf/P8zrLhe2iHYWFlIadiBM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
