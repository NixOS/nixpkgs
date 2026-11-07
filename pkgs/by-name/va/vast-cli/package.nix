{
  fetchFromGitHub,
  lib,
  python3Packages,

  nix-update-script,
}:
python3Packages.buildPythonApplication rec {
  pname = "vast-cli";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "vast-ai";
    repo = "vast-cli";
    tag = "v${version}";
    hash = "sha256-9SEPWRZnFRjZHh2NH3rpL3cThDcUAuXmtiU4js48m0g=";
  };

  pyproject = true;

  pythonRelaxDeps = true;

  nativeBuildInputs = [
    python3Packages.pythonRelaxDepsHook
  ];

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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Vast.ai python and cli api client";
    homepage = "https://vast.ai";
    changelog = "https://github.com/vast-ai/vast-cli/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ baileylu ];
    mainProgram = "vastai";
  };
}
