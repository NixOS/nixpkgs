{ lib
, buildGoModule
, fetchFromGitHub
, git
, nix-update-script
}:

buildGoModule {
  pname = "zoekt";
  version = "3.7.2-2-unstable-2024-09-19";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "zoekt";
    rev = "5379bc90f3f96b371b219beeb64340bcfd7f7149";
    hash = "sha256-1i95C11unZV7eUDxsRKRswwsxELH+oHXUbmY74c5mVs=";
  };

  vendorHash = "sha256-+ayixWCD2e+7Nh9WJmDAloSzp63v9hQYQd8UMuo8qxQ=";

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
