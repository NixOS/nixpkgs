{
  fetchFromGitHub,
  lib,
  python3Packages,

  nix-update-script,
  ...
}:
python3Packages.buildPythonApplication rec {
  pname = "vastai";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "vast-ai";
    repo = "vast-cli";
    tag = "v${version}";
    hash = "sha256-9SEPWRZnFRjZHh2NH3rpL3cThDcUAuXmtiU4js48m0g=";
  };

  pyproject = true;

  patches = [ ./remove-versions.patch ];

  dependencies = with python3Packages; [
    xdg
    argcomplete
    requests
    borb
    python-dateutil
    pytz
    urllib3
    poetry-dynamic-versioning
    gitpython
    toml
    curlify
    setuptools
    cryptography
  ];

  build-system = [ python3Packages.poetry-core ];

  meta = {
    description = "Vast.ai python and cli api client ";
    homepage = "https://vast.ai//";
    changelog = "https://github.com/vast-ai/vast-cli/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ baileylu ];
    platforms = lib.platforms.all;
    mainProgram = "vastai";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
    ];
  };

  passthru.updateScript = nix-update-script { };
}
