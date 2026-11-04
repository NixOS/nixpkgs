{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
buildGoModule (finalAttrs: {
  pname = "testkube";
  version = "2.14.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "testkube";
    tag = finalAttrs.version;
    hash = "sha256-M4yqT9qhV4SRowEpbaOcd+iJWOwO+lrgs7Qh1Dk8+Qo=";
  };

  vendorHash = "sha256-ju7qZlXjuskgK0hn/hbSGKrXCn8n5Y9VzB5o0X0JwdM=";

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
