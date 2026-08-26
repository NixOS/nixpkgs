{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "tf";
  version = "2.14.1";

  src = fetchFromGitHub {
    owner = "dex4er";
    repo = "tf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EBECIr6FU+4MI9wRvoP1Tp5sjgnGgBE5SZ6i/z3l+jo=";
  };

  vendorHash = "sha256-3/W7p2IW2KZtoIw+XjrNlaSgRgaZOEEu8HfKFzlPA2U=";

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
