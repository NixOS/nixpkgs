{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
}:

buildGoModule {
  pname = "zoekt";
  version = "0-unstable-2026-09-10";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "zoekt";
    rev = "f9c1afc84366173fc337271c6dd2372774eef63e";
    hash = "sha256-uLI8958VwM0uJpUUC81NPLPtECEr//YymWjA1b/crlU=";
  };

  vendorHash = "sha256-45aV6//ozC8oLkdLZ/phjP/+ftkzR7mULqQw5Jm1sIs=";

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
    maintainers = [ ];
    mainProgram = "zoekt";
  };
}
