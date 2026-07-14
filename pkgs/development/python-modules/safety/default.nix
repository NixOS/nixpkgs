{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  click,
  packaging,
  dparse,
  ruamel-yaml,
  jinja2,
  marshmallow,
  nltk,
  authlib,
  typer,
  pydantic,
  safety-schemas,
  typing-extensions,
  filelock,
  httpx,
  tenacity,
  tomlkit,
  truststore,
  git,
  pytestCheckHook,
  tomli,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "safety";
  version = "3.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyupio";
    repo = "safety";
    tag = finalAttrs.version;
    hash = "sha256-xKZ8uhwuM6eu1NTppPFTBkxSjrguTw9GuIvPhPaTIAI=";
  };

  patches = [
    ./disable-telemetry.patch
  ];

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    "safety-schemas"
  ];

  dependencies = [
    click
    packaging
    dparse
    ruamel-yaml
    jinja2
    marshmallow
    nltk
    authlib
    typer
    pydantic
    safety-schemas
    typing-extensions
    filelock
    httpx
    tenacity
    tomlkit
    truststore
  ];

  nativeCheckInputs = [
    git
    pytestCheckHook
    tomli
    writableTmpDirAsHomeHook
  ];

  disabledTestPaths = [
    # Failed to initialize SafetyPlatformClient: [Errno -3] Temporary failure in name resolution
    "tests/firewall/test_command.py"
    "tests/test_cli.py"
  ];

  meta = {
    description = "Checks installed dependencies for known vulnerabilities";
    mainProgram = "safety";
    homepage = "https://github.com/pyupio/safety";
    changelog = "https://github.com/pyupio/safety/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      thomasdesr
      dotlambda
    ];
  };
})
