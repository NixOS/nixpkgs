{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
buildGoModule (finalAttrs: {
  pname = "testkube";
  version = "2.15.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "testkube";
    tag = finalAttrs.version;
    hash = "sha256-I6soxDhIlYYEM7bmnAL+GCxwZ5hsXdL/RvTYVG5Mpi0=";
  };

  vendorHash = "sha256-nSjLQt8YFJSaw9Kv/vK+bKULV2ZkOa6bRjl47O+ez4E=";

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
