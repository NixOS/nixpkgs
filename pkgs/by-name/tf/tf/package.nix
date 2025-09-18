{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "tf";
  version = "2.11.1";

  src = fetchFromGitHub {
    owner = "dex4er";
    repo = "tf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EWD6BfOAZR/PucDhJmLStjBNVgXCLW45g8stVhoMyO8=";
  };

  vendorHash = "sha256-lcgLEj6NELZS0LoakbuektO4epieY7ctl8ya1JnXim8=";

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
