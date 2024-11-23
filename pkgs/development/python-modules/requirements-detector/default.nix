{
  lib,
  astroid,
  buildPythonPackage,
  fetchFromGitHub,
  packaging,
  poetry-core,
  semver,
  pytestCheckHook,
  pythonOlder,
  toml,
}:

buildPythonPackage rec {
  pname = "requirements-detector";
  version = "1.2.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "landscapeio";
    repo = "requirements-detector";
    rev = "refs/tags/${version}";
    hash = "sha256-qmrHFQRypBJOI1N6W/Dtc5ss9JGqoPhFlbqrLHcb6vc=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    astroid
    packaging
    toml
    semver
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "requirements_detector" ];

  meta = with lib; {
    description = "Python tool to find and list requirements of a Python project";
    homepage = "https://github.com/landscapeio/requirements-detector";
    changelog = "https://github.com/landscapeio/requirements-detector/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
    mainProgram = "detect-requirements";
    # https://github.com/landscapeio/requirements-detector/issues/48
    broken = versionAtLeast astroid.version "3";
  };
}
