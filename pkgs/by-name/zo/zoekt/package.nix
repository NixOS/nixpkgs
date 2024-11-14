{ lib
, buildGoModule
, fetchFromGitHub
, git
, nix-update-script
}:

buildGoModule {
  pname = "zoekt";
  version = "3.7.2-2-unstable-2024-12-09";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "zoekt";
    rev = "37c4df87f75cb0de7b71181301e0f6df6aa9ade6";
    hash = "sha256-pH21Kz/qMs7Cy1nKoaWOzUt6W9jBYtmgIiF6GIcdwsg=";
  };

  vendorHash = "sha256-Dvs8XMOxZEE9moA8aCxuxg947+x/6C8cKtgdcByL4Eo=";

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
