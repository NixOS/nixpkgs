{ lib
, buildGoModule
, fetchFromGitHub
, git
, nix-update-script
}:

buildGoModule {
  pname = "zoekt";
  version = "3.7.2-2-unstable-2024-10-24";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "zoekt";
    rev = "bfd8ee868c4c3fe509fa0fd4f2b8c68d84805ff9";
    hash = "sha256-hoKMD/nTX0r2PEM0qRhAQFXM45UhDztwK0epL2EIMY8=";
  };

  vendorHash = "sha256-QZysaEBZ1/ISPRkUPr6UIEUlWv/aHEwk8B/wxaYe7zU=";

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
