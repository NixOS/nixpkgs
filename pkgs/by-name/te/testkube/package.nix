{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
buildGoModule (finalAttrs: {
  pname = "testkube";
  version = "2.15.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "testkube";
    tag = finalAttrs.version;
    hash = "sha256-1io9xu8BC2cUJVrJKWUHAxiwr59jfH+uZ+dgLtlPvJg=";
  };

  vendorHash = "sha256-8m2qwk/2Kl23ldIqsF21T455lnpmKe6pT1svg5Z86Ps=";

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
