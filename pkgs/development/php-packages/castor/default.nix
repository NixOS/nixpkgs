{
  lib,
  fetchFromGitHub,
  fetchpatch,
  installShellFiles,
  php,
  nix-update-script,
  testers,
}:

php.buildComposerProject (finalAttrs: {
  pname = "castor";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "jolicode";
    repo = "castor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sSIkXNW6RR1mx15dKouQLMaHBr5FEkTTc/0QIkWV8sg=";
  };

  patches = [
    # Upstream lock is invalid. https://github.com/jolicode/castor/issues/319
    (fetchpatch {
      name = "fix-invalid-lock.patch";
      url = "https://github.com/jolicode/castor/commit/5ff0c3ecbdddad20146adbc2f055b83f5aadba0f.patch";
      hash = "sha256-1a3Dpk/UXp92Ugw9zSoLPsbWOJEuP2FBWc/pQ/EKwaM=";
    })
  ];

  vendorHash = "sha256-HfEjwlkozeuT4LDnYwiCu7T0spcf4GLhkd7Kc1VRnro=";

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
