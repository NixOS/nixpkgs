{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "tldx";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "brandonyoungdev";
    repo = "tldx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MEFj8GaHXoDo2rAP+tOnisgLSZDqleh4pzX7M4CZBUk=";
  };

  vendorHash = "sha256-+I1fFsHnOMK8oW810fj2cmD3jdunSFL/btaxLZCXcts=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
    "-X main.date=1970-01-01"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    license = lib.licenses.apsl20;
    mainProgram = "tldx";
    description = "Domain availability research tool";
    homepage = "https://github.com/brandonyoungdev/tldx";
    maintainers = with lib.maintainers; [ sylonin ];
  };
})
