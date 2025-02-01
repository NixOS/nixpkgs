{ lib
, buildGoModule
, fetchFromGitHub
, git
, nix-update-script
}:

buildGoModule {
  pname = "zoekt";
  version = "0-unstable-2024-09-05";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "zoekt";
    rev = "35dda3e212b7d7fb0df43dcbd88eb7a7b49ad9d8";
    hash = "sha256-YdInCAq7h7iC1sfMekLgxqu3plUHr5Ku6FxyPKluQzw=";
  };

  vendorHash = "sha256-GPeMRL5zWVjJVYpFPnB211Gfm/IaqisP1s6RNaLvN6M=";

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
