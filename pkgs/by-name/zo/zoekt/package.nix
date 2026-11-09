{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
}:

buildGoModule {
  pname = "zoekt";
  version = "0-unstable-2026-03-25";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "zoekt";
    rev = "a0f5789d25cb80a36bfb0b85cde2f004880bcbeb";
    hash = "sha256-y1BskdsrPrIRDFj9n7H6Dl17tS+4epwvShMe/i1I7KA=";
  };

  vendorHash = "sha256-WaO8/33pPmGh6tO/poD5epBknZjyzydG9dRuD67dYEw=";

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
