{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
buildGoModule (finalAttrs: {
  pname = "testkube";
  version = "2.12.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "testkube";
    tag = finalAttrs.version;
    hash = "sha256-5nKlOpSkr5YkocbfSZ/Zx19X3QSucSZV2UoNUAi09dI=";
  };

  vendorHash = "sha256-ppSf2NWtxF72W+aS83Hvs6jw3TZoXkN/qwMpAcV/224=";

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
