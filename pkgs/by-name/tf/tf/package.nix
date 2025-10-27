{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "tf";
  version = "2.11.2";

  src = fetchFromGitHub {
    owner = "dex4er";
    repo = "tf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JuGAUMOzAaiVjJf0R8I9PMc+g2m3SppQ+mdow7Qrvjc=";
  };

  vendorHash = "sha256-tI/Fk3jDaEdCnDc4VTLpJnVlsaSW4i00KfftEMIiWog=";

  subPackages = [ "." ];

  preInstallCheck = "make test";

  meta = {
    description = "Less verbose and more shell friendly Terraform";
    mainProgram = "tf";
    homepage = "https://github.com/dex4er/tf";
    changelog = "https://github.com/dex4er/tf/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Tenzer ];
  };
})
