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

buildPythonPackage rec {
  pname = "fjaraskupan";
  version = "2.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "elupus";
    repo = "fjaraskupan";
    tag = version;
    hash = "sha256-xu5u3hvtD1gbN1f1UuxDQVIHF5pyCOWVwUq36vAgW/Y=";
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
    changelog = "https://github.com/elupus/fjaraskupan/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
