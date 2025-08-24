{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
}:

buildGoModule {
  pname = "zoekt";
  version = "3.7.2-2-unstable-2025-08-18";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "zoekt";
    rev = "69b7ba714f8ab8f2083731464f169e7ca8234acd";
    hash = "sha256-CnjIP7+HeZEfG9b2UyC1mms2CSIijZC6Y4Gu1r1AXyU=";
  };

  vendorHash = "sha256-Yc1NZKb1V9NaZddnTnNOaqdNxOHKagl7Xpxj+mZf81I=";

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
    maintainers = with lib.maintainers; [ ];
    mainProgram = "zoekt";
  };
}
