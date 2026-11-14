{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGo127Module (finalAttrs: {
  pname = "yayamlls";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "home-operations";
    repo = "yayamlls";
    tag = finalAttrs.version;
    hash = "sha256-DmvqtaPeymYJD9n0Kd4+j1xnGhNnMwRYWIcIfFF705k=";
  };

  __structuredAttrs = true;

  vendorHash = "sha256-cHOVyjlY+xZ/4mcR//GCfhc/yCQrWxru368NLyTi5ko=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Schema-driven YAML language server with Kubernetes and Flux support";
    homepage = "https://github.com/home-operations/yayamlls";
    changelog = "https://github.com/home-operations/yayamlls/releases/tag/${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ mortebrume ];
    mainProgram = "yayamlls";
  };
})
