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
  version = "0.18.2";

  src = fetchFromGitHub {
    owner = "jolicode";
    repo = "castor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-f+vz3SFXnZS67dyHQyycONBtfydMVh2XjB/4r9QIak8=";
  };

  vendorHash = "sha256-U/L+iJ/DKCiUEbSUc/BgYeKakv0BdK6Eq5BJjtwb1Yk=";

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
