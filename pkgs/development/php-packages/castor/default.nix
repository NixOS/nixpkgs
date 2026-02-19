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
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "jolicode";
    repo = "castor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yTfSRB+Kr244lX4uIttCJltunGe3C67Ti8EUkZQsOIA=";
  };

  vendorHash = "sha256-OkW7I8nowjqd3bmvQwnqog6V73T9C+F763/QNcCXZNM=";

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
