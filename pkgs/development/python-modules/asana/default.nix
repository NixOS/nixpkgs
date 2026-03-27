{
  lib,
  buildPythonPackage,
  certifi,
  fetchFromGitHub,
  pytestCheckHook,
  python-dateutil,
  python-dotenv,
  setuptools,
  six,
  urllib3,
}:

buildPythonPackage rec {
  pname = "asana";
  version = "5.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "asana";
    repo = "python-asana";
    tag = "v${version}";
    hash = "sha256-GyNf5fr/cuwFSCQFsXno92ZOCVW88BWAVjzScVvnQdo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    certifi
    six
    python-dateutil
    python-dotenv
    urllib3
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "asana" ];

  disabledTestPaths = [
    # Tests require network access
    "build_tests/"
  ];

  meta = {
    description = "Python client library for Asana";
    homepage = "https://github.com/asana/python-asana";
    changelog = "https://github.com/Asana/python-asana/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
