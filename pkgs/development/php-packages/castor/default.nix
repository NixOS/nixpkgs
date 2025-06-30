{
  lib,
  fetchFromGitHub,
  installShellFiles,
  php,
  nix-update-script,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "castor";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "jolicode";
    repo = "castor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qHCW/VHHMk8+/RL2HEW+RyaZaq7MsxB9RePwmgYHpDI=";
  };

  vendorHash = "sha256-DJ8iHhkLfe1GNf7eJHeE8ORt9cyRFLr0gLGeHENiASw=";

  nativeBuildInputs = [ installShellFiles ];

  # install shell completions
  postInstall = ''
    installShellCompletion --cmd castor \
      --bash <(php $out/bin/castor completion bash) \
      --fish <(php $out/bin/castor completion fish) \
      --zsh <(php $out/bin/castor completion zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    broken = lib.versionOlder php.version "8.2";
    changelog = "https://github.com/jolicode/castor/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "DX oriented task runner and command launcher built with PHP";
    homepage = "https://github.com/jolicode/castor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gaelreyrol ];
    mainProgram = "castor";
  };
})
