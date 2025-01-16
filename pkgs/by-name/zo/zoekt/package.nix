{ lib
, buildGoModule
, fetchFromGitHub
, git
, nix-update-script
}:

buildGoModule {
  pname = "zoekt";
  version = "3.7.2-2-unstable-2025-01-08";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "zoekt";
    rev = "b51a2335d51b865e1ffe84aa549e85570da61463";
    hash = "sha256-D8jQ/u5kKRbOihbsX4U7RsoRoyqcJCqrELFt4YTgyj4=";
  };

  vendorHash = "sha256-laiBp+nMWEGofu7zOgfM2b8MIC+Dfw7eCLgb/5zf9oo=";

  nativeCheckInputs = [
    git
  ];

  preCheck = ''
    export HOME=`mktemp -d`
    git config --global --replace-all protocol.file.allow always
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version" "branch" ];
  };

  meta = {
    description = "Fast trigram based code search";
    homepage = "https://github.com/sourcegraph/zoekt";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    mainProgram = "zoekt";
  };
}
