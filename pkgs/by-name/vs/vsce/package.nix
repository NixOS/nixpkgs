{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  libsecret,
  python3,
  testers,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "vsce";
  version = "3.6.2";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vscode-vsce";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TcBzXDNpjJvI+0ir80d+HFp6mF/Ecle4vhOMcACvF7M=";
  };

  npmDepsHash = "sha256-G09pn6JX389GMbIzYmmLutH7qwiaDb8V9zCGAOFaDdk=";

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
      package = finalAttrs.finalPackage;
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
