{
  lib,
  fetchFromGitHub,
  installShellFiles,
  php,
  nix-update-script,
  testers,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "castor";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "jolicode";
    repo = "castor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GTsPcivETNP3x8kEI18CsUtV2ouAMkpC/uO+ltSkpnQ=";
  };

  vendorHash = "sha256-gJgItrEPHgSF2ReNLT4HAK9Dlx9uB6f0rXQ2A7WsNNE=";

  nativeBuildInputs = [ installShellFiles ];

  # install shell completions
  postInstall = ''
    installShellCompletion --cmd castor \
      --bash <(php $out/bin/castor completion bash) \
      --fish <(php $out/bin/castor completion fish) \
      --zsh <(php $out/bin/castor completion zsh)
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      command = "castor --version";
      package = php.packages.castor;
      version = "v${finalAttrs.version}";
    };
  };

  meta = {
    changelog = "https://github.com/jolicode/castor/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "DX oriented task runner and command launcher built with PHP";
    homepage = "https://github.com/jolicode/castor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gaelreyrol ];
    mainProgram = "castor";
  };
})
