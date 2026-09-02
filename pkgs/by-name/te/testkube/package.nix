{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
buildGoModule (finalAttrs: {
  pname = "testkube";
  version = "2.13.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "testkube";
    tag = finalAttrs.version;
    hash = "sha256-mwles/jGwyQ447gmhfMrojMJ6rFtVNzvjhfmYGg3PZY=";
  };

  vendorHash = "sha256-v19tJhevIRD1GWByZViuHPQ6fYiLgXNLe1DksUQb59o=";

  ldflags = [
    "-X main.version=${finalAttrs.version}"
    "-X main.builtBy=nixpkgs"
    "-X main.commit=v${finalAttrs.version}"
    "-X main.date=1970-01-01-00:00:01"
  ];

  subPackages = [ "cmd/kubectl-testkube" ];

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  meta = {
    description = "Kubernetes-native framework for test definition and execution";
    homepage = "https://github.com/kubeshop/testkube/";
    license = lib.licenses.mit;
    mainProgram = "kubectl-testkube";
    maintainers = with lib.maintainers; [ mathstlouis ];
  };
})
