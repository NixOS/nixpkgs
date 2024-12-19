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
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vscode-vsce";
    rev = "v${version}";
    hash = "sha256-S49tX0e0XW7RasYeFALKexP8516+7Umtglh1h6f5wEQ=";
  };

  npmDepsHash = "sha256-k6LdGCpVoBNpHe4z7NrS0T/gcB1EQBvBxGAM3zo+AAo=";

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
