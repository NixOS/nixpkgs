{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "templ";
  version = "0.3.1070";

  src = fetchFromGitHub {
    owner = "a-h";
    repo = "templ";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9H5X5eiBP1n9CFlWtor3ZdF6uCNPoQdkoi90cyU+kxA=";
  };

  vendorHash = "sha256-WXUlbUR+5a0BRStFF4A9mMjGiYFL5ULu1yrRhIG0vwc=";

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
