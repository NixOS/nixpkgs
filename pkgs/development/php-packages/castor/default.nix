{ lib
, fetchFromGitHub
, installShellFiles
, php
, nix-update-script
, testers
}:

php.buildComposerProject (finalAttrs: {
  pname = "castor";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "jolicode";
    repo = "castor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FqFCKvhOEtDERNRLB3613geEiNDOlQuLeCa5uVvoMdM=";
  };

  vendorHash = "sha256-+ORwa3+tkVJ9KU+9URg+1lyHoL1swxg6DG5ex8HjigE=";

  nativeBuildInputs = [ installShellFiles ];

  # install shell completions
  postInstall = ''
    echo "yes" | ${php}/bin/php $out/share/php/castor/bin/castor
    installShellCompletion --cmd castor \
      --bash <(${php}/bin/php $out/share/php/castor/bin/castor completion bash) \
      --fish <(${php}/bin/php $out/share/php/castor/bin/castor completion fish) \
      --zsh <(${php}/bin/php $out/share/php/castor/bin/castor completion zsh)
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
