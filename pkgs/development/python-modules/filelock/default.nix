{ lib
, buildPythonPackage
, fetchPypi
, hatch-vcs
, hatchling
, pytest-mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "filelock";
  version = "3.12.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Lm8knx82VCkWBuBGsJ8f1erDmzYGZMJ/Wq0HIBL4vL0=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/tox-dev/py-filelock/releases/tag/${version}";
    description = "A platform independent file lock for Python";
    homepage = "https://github.com/benediktschmitt/py-filelock";
    license = licenses.unlicense;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
