{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  libsecret,
  python3,
  testers,
  vsce,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "vsce";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vscode-vsce";
    rev = "v${finalAttrs.version}";
    hash = "sha256-55yiW2BJe0AlfHit8gpZJyZSHqVq6kywuEtZ5HGcfT0=";
  };

  npmDepsHash = "sha256-tUboOVkZY4iag+36aJLbHGJqqlFE7fx8BXK50G7DJ64=";

  postPatch = ''
    substituteInPlace package.json --replace-fail '"version": "0.0.0"' '"version": "${finalAttrs.version}"'
  '';

  nativeBuildInputs = [
    pkg-config
    python3
  ];

  buildInputs = [ libsecret ];

  makeCacheWritable = true;
  npmFlags = [ "--legacy-peer-deps" ];

  passthru = {
    tests.version = testers.testVersion {
      package = vsce;
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^v(\\d+\\.\\d+\\.\\d+)$"
      ];
    };
  };

  meta = {
    homepage = "https://github.com/microsoft/vscode-vsce";
    description = "Visual Studio Code Extension Manager";
    maintainers = with lib.maintainers; [ aaronjheng ];
    license = lib.licenses.mit;
    mainProgram = "vsce";
  };
})
