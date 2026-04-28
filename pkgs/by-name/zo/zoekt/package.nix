{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
}:

buildGoModule {
  pname = "zoekt";
  version = "0-unstable-2026-04-28";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "zoekt";
    rev = "cd5247d8a2c1124f0816fe02e9317dc89570a7cf";
    hash = "sha256-xEM56u83U3kkpH27tTnCXtqQUVEDppvHXzapxoeaagY=";
  };

  vendorHash = "sha256-QEYdf08kQXS+KwnZzzVDTzPwRmNsI6NWOZ0/LbBsa14=";

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
