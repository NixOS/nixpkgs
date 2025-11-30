{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,

  writableTmpDirAsHomeHook,

  stdenv,
  buildPackages,

  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "tektoncd-cli";
  version = "0.43.0";

  src = fetchFromGitHub {
    owner = "tektoncd";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-75pyN+Sr5IttqrQYIveePabcuxnx8G48aiP5rw2v/Jo=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/tektoncd/cli/pkg/cmd/version.clientVersion=${finalAttrs.version}"
  ];

  # tests bind to ::1
  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [
    "cmd/tkn"
  ];

  excludedPackages = [
    "test/e2e"
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    # run all tests
    unset subPackages

    # the tests expect the clientVersion ldflag not to be set
    unset ldflags
  '';

  postInstall = ''
    installManPage docs/man/man1/*
  ''
  + (
    let
      exe =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}"
        else
          lib.getExe buildPackages.tektoncd-cli;
    in
    ''
      installShellCompletion --cmd ${finalAttrs.meta.mainProgram} \
        --bash <(${exe} completion bash) \
        --fish <(${exe} completion fish) \
        --zsh <(${exe} completion zsh)
    ''
  );

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgramArg = "version";

  meta = {
    homepage = "https://tekton.dev";
    changelog = "https://github.com/tektoncd/cli/releases/tag/${finalAttrs.src.tag}";
    description = "Provides a CLI for interacting with Tekton - tkn";
    longDescription = ''
      The Tekton Pipelines cli project provides a CLI for interacting with
      Tekton! For your convenience, it is recommended that you install the
      Tekton CLI, tkn, together with the core component of Tekton, Tekton
      Pipelines.
    '';
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jk
      mstrangfeld
      vdemeester
    ];
    mainProgram = "tkn";
  };
})
