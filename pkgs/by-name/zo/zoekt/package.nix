{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
}:

buildGoModule {
  pname = "zoekt";
  version = "3.7.2-2-unstable-2025-03-25";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "zoekt";
    rev = "47287adecfbd6b068cf7ad5fb67c9548a7062156";
    hash = "sha256-RRlCfv34hSBWpeXxvXsPtfziE0L0FhZfMIfBi8i2XWg=";
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
