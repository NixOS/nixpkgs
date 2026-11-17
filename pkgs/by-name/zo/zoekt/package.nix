{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
}:

buildGoModule {
  pname = "zoekt";
  version = "0-unstable-2026-11-16";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "zoekt";
    rev = "33ce1d04d373d9c8dcdb8b0a67119dedb6345ccc";
    hash = "sha256-73WTKDHb/sAjhS5sURGAC9Fq2MziBBId0ucvUki8wLo=";
  };

  vendorHash = "sha256-3fuc7rWNpfIyc9t3ggOfHOpoX4duSHCmqGcLO7GGeBU=";

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
