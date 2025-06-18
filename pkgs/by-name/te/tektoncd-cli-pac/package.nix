{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "tektoncd-cli-pac";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "openshift-pipelines";
    repo = "pipelines-as-code";
    tag = "v${version}";
    hash = "sha256-d8AOMoWQOoxK0kr+HokSaiFNCDmcc5sOEn1TEFNbx2U=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/tkn-pac" ];

  postInstall = ''
    installShellCompletion --cmd tkn-pac \
      --bash <($out/bin/tkn-pac completion bash) \
      --fish <($out/bin/tkn-pac completion fish) \
      --zsh <($out/bin/tkn-pac completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/tkn-pac --help
    runHook postInstallCheck
  '';

  meta = {
    homepage = "https://pipelinesascode.com";
    changelog = "https://github.com/openshift-pipelines/pipelines-as-code/releases/tag/v${version}";
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
}
