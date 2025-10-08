{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "tektoncd-cli-pac";
  version = "0.37.1";

  src = fetchFromGitHub {
    owner = "openshift-pipelines";
    repo = "pipelines-as-code";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LgEXxFBj8mnYAYJFunmH9Ip/T7NcU9uHoaxz4maBCxM=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/openshift-pipelines/pipelines-as-code/pkg/params/version.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/tkn-pac" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd tkn-pac \
      --bash <($out/bin/tkn-pac completion bash) \
      --fish <($out/bin/tkn-pac completion fish) \
      --zsh <($out/bin/tkn-pac completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://pipelinesascode.com";
    changelog = "https://github.com/openshift-pipelines/pipelines-as-code/releases/tag/v${finalAttrs.version}";
    description = "CLI for interacting with Tekton Pipelines as Code";
    longDescription = ''
      tkn-pac CLI Plugin – Easily manage Pipelines-as-Code repositories.
    '';
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      netbrain
      vdemeester
      chmouel
    ];
    mainProgram = "tkn-pac";
  };
})
