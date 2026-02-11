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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "jolicode";
    repo = "castor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HgFFy/qEN7fPCFqDJe1SLMpDWB04YPI6OPYaURqjyKQ=";
  };

  vendorHash = "sha256-RBN99M5YFee8FZURn4lVuscrCmajMNn+10KgwqgPk8k=";

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

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/jolicode/castor/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "DX oriented task runner and command launcher built with PHP";
    homepage = "https://github.com/jolicode/castor";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "castor";
  };
})
