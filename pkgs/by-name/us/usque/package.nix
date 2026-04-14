{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  nix-update-script,
  buildPackages,
  installShellFiles,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "usque";
  version = "2.0.1";
  src = fetchFromGitHub {
    owner = "Diniboy1123";
    repo = "usque";
    tag = "v${finalAttrs.version}";
    hash = "sha256-veAUc2LeH2NoOs3AHj8GUr7zBPidHtr+JlUQjgo/WQQ=";
  };

  vendorHash = "sha256-pilBazQcrfCcgBCo9U9jGo/ZcuXLBR3kT8l+mad+umg=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/Diniboy1123/usque/cmd.version=${finalAttrs.version}"
  ];
  nativeBuildInputs = [ installShellFiles ];
  postInstall =
    let
      exe =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out/bin/usque"
        else
          lib.getExe buildPackages.usque;
    in
    ''
      installShellCompletion --cmd usque \
        --bash <(${exe} completion bash) \
        --fish <(${exe} completion fish) \
        --zsh <(${exe} completion zsh)
    '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "usque";
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "Open-source reimplementation of the Cloudflare WARP client's MASQUE protocol";
    homepage = "https://github.com/Diniboy1123/usque";
    license = lib.licenses.mit;
    changelog = "https://github.com/Diniboy1123/usque/releases/tag/v${finalAttrs.version}";
  };
})
