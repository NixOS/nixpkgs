{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "tf";
  version = "2.14.2";

  src = fetchFromGitHub {
    owner = "dex4er";
    repo = "tf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-L7XKSVuzUA5Igse4Oh7fqtT0iM6aqO9k5bpYco39TfI=";
  };

  vendorHash = "sha256-aStC8p/IYX3ExclRif4ASiLhX70xExMrUN4VBA74bLE=";

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
