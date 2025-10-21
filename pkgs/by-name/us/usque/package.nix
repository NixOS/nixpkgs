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
  version = "1.4.2";
  src = fetchFromGitHub {
    owner = "Diniboy1123";
    repo = "usque";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U2C0To9WaQZaAuWbx3+h4hhDI8n3H55cXOnS9l2l2rY=";
  };

  vendorHash = "sha256-SS0Lqdfdp3hO2hUW0oRXH9jQWW/68a/tKYU7PMgeQYs=";

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
