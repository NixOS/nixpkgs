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
  version = "4.2.1";
  src = fetchFromGitHub {
    owner = "Diniboy1123";
    repo = "usque";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aUAji41gVsRs47IDtLAinxUZsZjTQvO/SMWe5GdmJLw=";
  };

  vendorHash = "sha256-XvbH6w0po2piUwuHTRxGbqwoKEOl2nLp0VnXONOvA14=";

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
    maintainers = with lib.maintainers; [
      xddxdd
      xyenon
    ];
    description = "Open-source reimplementation of the Cloudflare WARP client's MASQUE protocol";
    homepage = "https://github.com/Diniboy1123/usque";
    license = lib.licenses.mit;
    changelog = "https://github.com/Diniboy1123/usque/releases/tag/v${finalAttrs.version}";
  };
})
