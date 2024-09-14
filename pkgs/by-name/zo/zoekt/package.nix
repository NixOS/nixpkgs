{ lib
, buildGoModule
, fetchFromGitHub
, git
, nix-update-script
}:

buildGoModule {
  pname = "zoekt";
  version = "3.7.2-2-unstable-2024-09-10";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "zoekt";
    rev = "44eab0c512ef7ff25b09b2c133d4cba3d9850519";
    hash = "sha256-ZQs0JPCEIA1+mxOm/uhu+Ulhb393kE7fBz/zUIcvRRE=";
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
