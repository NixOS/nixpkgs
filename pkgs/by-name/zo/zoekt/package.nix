{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
}:

buildGoModule {
  pname = "zoekt";
  version = "3.7.2-2-unstable-2025-01-21";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "zoekt";
    rev = "e7f0a1a349e11e1e834de840312e23716aeb0b95";
    hash = "sha256-uH9v/Fxkfue2AWppDRpMJ0ROXOYo59GV2aAAKfYDU3M=";
  };

  vendorHash = "sha256-7bpoUxhoVc74bN9/B6TWyufSvDRD90KpIXUMKK+3BcU=";

  nativeCheckInputs = [
    gitMinimal
  ];

  preCheck = ''
    export HOME=`mktemp -d`
    git config --global --replace-all protocol.file.allow always
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    description = "Fast trigram based code search";
    homepage = "https://github.com/sourcegraph/zoekt";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    mainProgram = "zoekt";
  };
}
