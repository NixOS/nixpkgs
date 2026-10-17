{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  flake8,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-flake8-path";
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = "pytest-flake8-path";
    tag = finalAttrs.version;
    hash = "sha256-YdXrFz4yOL37e7wtfxcjNfeL54WQTa4a61qF2kuoNBU=";
  };

  build-system = [ setuptools ];
  dependencies = [ flake8 ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "pytest_flake8_path" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "pytest fixture for testing flake8 plugins";
    homepage = "https://github.com/adamchainz/pytest-flake8-path";
    changelog = "https://github.com/adamchainz/pytest-flake8-path/blob/main/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ winter ];
  };
})
