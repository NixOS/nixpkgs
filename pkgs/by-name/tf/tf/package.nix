{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "tf";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "dex4er";
    repo = "tf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a/IWfiBZkRLgJWiEGzyWOpyZfI1EQkIsYaiNuRwH6hE=";
  };

  vendorHash = "sha256-h1ApWUK62l4O9Xr6TyXM++uzYqWkxlzvgZOwkWMYke0=";

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
