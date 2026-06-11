{
  lib,
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-mock,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "fjaraskupan";
  version = "2.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "elupus";
    repo = "fjaraskupan";
    tag = finalAttrs.version;
    hash = "sha256-0rJoUQYexB+4ehOXKa1aca401E7opDtdoBmIW/2uOOE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bleak
    bleak-retry-connector
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "fjaraskupan" ];

  meta = {
    description = "Module for controlling Fjäråskupan kitchen fans";
    homepage = "https://github.com/elupus/fjaraskupan";
    changelog = "https://github.com/elupus/fjaraskupan/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
