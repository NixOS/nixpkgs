{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "tuios";
  version = "0.11.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Gaurav-Gosain";
    repo = "tuios";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ifgOqJGihtLQIpdfNJZ27mhqGwKvJ/bxR2/4cmGR1q4=";
  };

  vendorHash = "sha256-oxVsw2uNyl8wgdlsUaxTbA3yxO5AT118sGz2E5ygyCs=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.tag}"
    "-X=main.date=1970-01-01T00:00:00Z"
    "-X=main.builtBy=nixpkgs"
  ];

  env.GOWORK = "off";
  __darwinAllowLocalNetworking = true;

  subPackages = [
    "cmd/tuios"
    "cmd/tuios-web"
  ];

  nativeBuildInputs = [ installShellFiles ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  checkFlags =
    let
      skippedTests = [
        "TestCheckTransferShapeRefusesWhatBundleWorktreeCannotSend" # needs a repo
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ${finalAttrs.meta.mainProgram} \
      --bash <($out/bin/${finalAttrs.meta.mainProgram} completion bash) \
      --fish <($out/bin/${finalAttrs.meta.mainProgram} completion fish) \
      --zsh <($out/bin/${finalAttrs.meta.mainProgram} completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal-based window manager";
    homepage = "https://github.com/Gaurav-Gosain/tuios";
    changelog = "https://github.com/Gaurav-Gosain/tuios/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kpbaks
      adamcstephens
    ];
    mainProgram = "tuios";
  };
})
