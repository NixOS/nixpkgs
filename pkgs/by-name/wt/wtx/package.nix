{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  git,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "wtx";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "bkildow";
    repo = "wtx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/MwKxKptFbwp3Kjsj0r+NQn5+SpCaz7NMH79BW9yCg8=";
  };

  vendorHash = "sha256-ZlZmC2FwPv7RFUIUpyMA80iHNrOIbAMDpVObXJ2VSuY=";

  __structuredAttrs = true;

  # e2e runs generated `#!/usr/bin/env bash` scripts and needs bash's `complete` builtin;
  # the sandbox has neither /usr/bin/env nor interactive bash
  excludedPackages = [ "e2e" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/bkildow/wtx/cmd.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [ git ];

  # Executes a generated `#!/usr/bin/env bash` script; the Linux sandbox has no /usr/bin/env
  checkFlags = [ "-skip=^TestWriteStarterScripts$" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd wtx \
      --bash <($out/bin/wtx completion bash) \
      --fish <($out/bin/wtx completion fish) \
      --zsh <($out/bin/wtx completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Git worktree manager CLI";
    homepage = "https://github.com/bkildow/wtx";
    changelog = "https://github.com/bkildow/wtx/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ adamwett ];
    mainProgram = "wtx";
  };
})
