{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  httpx,
  idapro,
  nix-update-script,
  packaging,
  pexpect,
  pip,
  platformdirs,
  pydantic,
  pytest-asyncio,
  pytest-httpx,
  pytest-mock,
  pytestCheckHook,
  questionary,
  rich-click,
  rich,
  semantic-version,
  setuptools,
  tenacity,
  tomli,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ida-hcli";
  version = "0.18.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "HexRaysSA";
    repo = "ida-hcli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5ymjKms3qtprIwd81PpmXgewDi4jSLlblgD/9b8Kzt8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    httpx
    idapro
    packaging
    pip
    platformdirs
    pydantic
    questionary
    rich
    rich-click
    semantic-version
    tenacity
    tomli
  ];

  nativeCheckInputs = [
    pexpect
    pytest-asyncio
    pytest-httpx
    pytest-mock
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "hcli" ];

  disabledTestPaths = [
    # Tests require IDA to be installed and configured
    "tests/integration/"
    "tests/lib/test_ida_python.py"
    "tests/lib/test_ida.py"
    "tests/lib/test_plugin_bundle_install.py"
    "tests/lib/test_plugin_collisions.py"
    "tests/lib/test_plugin_install.py"
    "tests/lib/test_plugin_records.py"
    "tests/lib/test_plugin_settings.py"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for IDA plugin management and configuration";
    homepage = "https://github.com/HexRaysSA/ida-hcli";
    changelog = "https://github.com/HexRaysSA/ida-hcli/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "hcli";
  };
})
