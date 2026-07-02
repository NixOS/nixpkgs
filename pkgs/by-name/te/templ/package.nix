{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "templ";
  version = "0.3.1001";

  src = fetchFromGitHub {
    owner = "a-h";
    repo = "templ";
    rev = "v${finalAttrs.version}";
    hash = "sha256-146QxN+osvlzp8NTGm5TN2yvbu3cOodXfIVeIKsS+7I=";
  };

  vendorHash = "sha256-pVZjZCXT/xhBCMyZdR7kEmB9jqhTwRISFp63bQf6w5A=";

  subPackages = [ "cmd/templ" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-extldflags -static"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language for writing HTML user interfaces in Go";
    homepage = "https://github.com/a-h/templ";
    license = lib.licenses.mit;
    mainProgram = "templ";
    maintainers = with lib.maintainers; [ luleyleo ];
  };
})
