{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
}:

buildGoModule {
  pname = "zoekt";
  version = "3.7.2-2-unstable-2025-04-15";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "zoekt";
    rev = "0978c13fb6683be9908ee1a578360734e61cc8b5";
    hash = "sha256-1Ris2GsZnHHrxvXxOCRSPvvk35YEhqDxNHkd7cjv0YY=";
  };

  vendorHash = "sha256-B45Q9G+p/idqqz45lLQQuDGLwAzhKuo9Ev+cISGbKUo=";

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
    maintainers = with lib.maintainers; [ ];
    mainProgram = "zoekt";
  };
}
