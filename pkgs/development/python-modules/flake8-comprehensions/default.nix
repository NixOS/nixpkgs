{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  flake8,
  pytestCheckHook,
  pytest-flake8-path,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "flake8-comprehensions";
  version = "3.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = "flake8-comprehensions";
    tag = finalAttrs.version;
    hash = "sha256-czSMAUO+dOC3WNQi/P8duu/wlNtiPlRpI65VZ8wOfSc=";
  };

  build-system = [ setuptools ];
  dependencies = [ flake8 ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-flake8-path
  ];
  pythonImportsCheck = [ "flake8_comprehensions" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "flake8 plugin to help you write better list/set/dict comprehensions";
    homepage = "https://github.com/adamchainz/flake8-comprehensions";
    changelog = "https://github.com/adamchainz/flake8-comprehensions/blob/${finalAttrs.version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ winter ];
  };
})
