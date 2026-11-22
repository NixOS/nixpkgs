{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  nix-update-script,
}:
buildGo127Module (finalAttrs: {
  pname = "tsidp";
  version = "0.0.18";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tsidp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oL+WH5iFVRd0erh3KfJrvUMIpZraomHoRzo5sh3duu0=";
  };

  vendorHash = "sha256-X3o71xgGBFJM3Sspb+223NYsDwJ3jf+9lCWQxS6JDA8=";

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
