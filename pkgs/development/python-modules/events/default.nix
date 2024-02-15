{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "events";
  version = "0.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pyeve";
    repo = "events";
    rev = "refs/tags/v${version}";
    hash = "sha256-GGhIKHbJ31IN0Uoe689X9V/MZvtseE47qx2CmM4MYUs=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "events"
  ];

  pytestFlagsArray = [
    "events/tests/tests.py"
  ];

  meta = with lib; {
    description = "Bringing the elegance of C# EventHanlder to Python";
    homepage = "https://events.readthedocs.org";
    changelog = "https://github.com/pyeve/events/blob/v0.5/CHANGES";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
