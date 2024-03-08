{ lib
, fetchFromGitHub
, installShellFiles
, php
, nix-update-script
, testers
}:

php.buildComposerProject (finalAttrs: {
  pname = "castor";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "jolicode";
    repo = "castor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Sm6I306iKVr66sBp+ADeTZAKGToVMc+Y/BCymUdszNc=";
  };

  vendorHash = "sha256-KbmovAnejShyVclF4IcZ9ckUOWysfEz3DFqE8OxlzI0=";

  nativeBuildInputs = [ installShellFiles ];

  # install shell completions
  postInstall = ''
    installShellCompletion --cmd castor \
      --bash <($out/bin/castor completion bash) \
      --fish <($out/bin/castor completion fish) \
      --zsh <($out/bin/castor completion zsh)
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
