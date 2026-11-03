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
  truststore,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ida-hcli";
  version = "0.27.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "HexRaysSA";
    repo = "ida-hcli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6K7G8pOYPRpkdvSdoWbDl8TDJnWl3sPNdxmwhBcC+rc=";
  };

  postPatch = ''
    # mix_stderr was removed in Click 8.2
    find tests -name "*.py" -exec sed -i 's/CliRunner(mix_stderr=False)/CliRunner()/g' {} +
  '';

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
    truststore
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
    "tests/lib/test_plugin_collisions.py"
    "tests/lib/test_plugin_install.py"
    "tests/lib/test_plugin_records.py"
    "tests/lib/test_plugin_settings.py"
    # Tests require network access (uv pip install / venv creation)
    "tests/lib/test_plugin_dependency_migration.py"
    "tests/lib/test_python_environment_commands.py"
  ];

  disabledTests = [
    # Require network access for uv pip install
    "test_airgapped_workflow_bundle_repo"
    "test_install_from_extracted_bundle_directory"
    "test_offline_install_from_named_bundle_repository"
    # Require network access for pip wheel download
    "test_download_cell_wheelhouse_includes_optional_dependency_with_wheels"
    "test_download_cell_wheelhouse_skips_optional_dependency_without_wheels"
    "test_download_cell_wheelhouse_fails_for_required_python_dependency_without_wheels"
    "test_bundle_create_downloads_wheels_without_ida"
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
