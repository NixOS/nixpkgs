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
<<<<<<< HEAD
  version = "0.40.0";
=======
  version = "0.39.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "openshift-pipelines";
    repo = "pipelines-as-code";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-FHhJyOHaYaYvizNZ3iKsWy+CH9VWa8LXBmaawVdcaFo=";
=======
    hash = "sha256-iGa4aemterN59wLQCzg8RMl2z71obabQ5GTwz7I/mPs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "v([0-9.]+)"
    ];
  };
=======
  passthru.updateScript = nix-update-script { };
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
