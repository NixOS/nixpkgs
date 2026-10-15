{
  lib,
  fetchFromGitHub,
  installShellFiles,
  php,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "castor";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "jolicode";
    repo = "castor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-naG0SBWARro92PGUA9dAKMYCGYEA/vsXOA8inAIcXkk=";
  };

  vendorHash = "sha256-4YNO5dNtZnnP/UFUax/GQ+UBcIbzXfYwB7yQv6Mf7ig=";

  nativeBuildInputs = [
    installShellFiles
    writableTmpDirAsHomeHook
  ];

  # install shell completions
  postInstall = ''
    installShellCompletion --cmd castor \
      --bash <(php $out/bin/castor completion bash) \
      --fish <(php $out/bin/castor completion fish) \
      --zsh <(php $out/bin/castor completion zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckKeepEnvironment = [ "HOME" ];

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
    broken = lib.versionOlder php.version "8.4";
  };
})
