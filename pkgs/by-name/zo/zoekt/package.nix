{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
}:

buildGoModule {
  pname = "zoekt";
  version = "3.7.2-2-unstable-2025-07-14";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "zoekt";
    rev = "a4188d22d917b834cca2da69bffc41a6d19302ac";
    hash = "sha256-7YBA3K2FW/FyRBwxZlahM3mji/2sWTfFm2IBD7PxmYs=";
  };

  vendorHash = "sha256-1WfQbvT5pKZRfs2DWv6+jBpHKGpcxhYAnc+NXvMT6WE=";

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
