{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "tsidp";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tsidp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u6dQORtB4eNEFLlouuFV5oxedSN1fZ31YkZavfU1F0U=";
  };

  vendorHash = "sha256-obtcJTg7V4ij3fGVmZMD7QQwKJX6K5PPslpM1XKCk9Q=";

  meta = {
    homepage = "https://github.com/tailscale/tsidp";
    changelog = "https://github.com/tailscale/tsidp/releases/tag/v${finalAttrs.version}";
    description = "Simple OIDC / OAuth Identity Provider (IdP) server for your tailnet";
    license = lib.licenses.bsd3;
    mainProgram = "tsidp";
    maintainers = with lib.maintainers; [ akotro ];
  };
})
