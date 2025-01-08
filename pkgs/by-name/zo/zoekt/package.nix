{ lib
, buildGoModule
, fetchFromGitHub
, git
, nix-update-script
}:

buildGoModule {
  pname = "zoekt";
  version = "3.7.2-2-unstable-2024-12-18";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "zoekt";
    rev = "dc1b23bb0da9a0fa91056ad6d5fcf9b8e641f67d";
    hash = "sha256-sMYGFA6zazY64IGELbp4H1xNfKeH72pJ7bJ0Vy9YYFk=";
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
