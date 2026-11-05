{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
}:

buildGoModule {
  pname = "zoekt";
  version = "0-unstable-2026-11-03";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "zoekt";
    rev = "a5a933bc043e08f092559801cfcc213ac942103d";
    hash = "sha256-TwQWjnEoIatd8DCABJia8ejfEnh9LceFvn+87OvVzEs=";
  };

  vendorHash = "sha256-Vm5Mpzm7i6v1LxtnwkWbkCa09JlVGKnyIwXD6unqLXc=";

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
