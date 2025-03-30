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

buildNpmPackage rec {
  pname = "vsce";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vscode-vsce";
    rev = "v${version}";
    hash = "sha256-z2OxVK/zbKr1AvWO74aoZHU/e3GPCF0QMINdNhbzNXc=";
  };

  npmDepsHash = "sha256-RIurea4cdH47q9axGtNTIZMeDOAqqdjovaE34A7M2uI=";

  postPatch = ''
    substituteInPlace package.json --replace-fail '"version": "0.0.0"' '"version": "${version}"'
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
}
