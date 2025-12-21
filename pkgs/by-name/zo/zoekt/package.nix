{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
}:

buildGoModule {
  pname = "zoekt";
  version = "0-unstable-2025-12-02";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "zoekt";
    rev = "886b229dcd5e7bec0c9918002b77345d27c84e3c";
    hash = "sha256-8Dc/jIXpA7PnQeU719RcK8s/nM1QAGw3MVhxw3Wb0yc=";
  };

  vendorHash = "sha256-1QM6OVFXS88IryKuNJKcbgYZcRZ+E6Na5NqItAlicXw=";

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
