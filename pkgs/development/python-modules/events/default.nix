<<<<<<< HEAD
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
=======
{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "Events";
  version = "0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01d9dd2a061f908d74a89fa5c8f07baa694f02a2a5974983663faaf7a97180f5";
  };

  meta = with lib; {
    homepage = "https://events.readthedocs.org";
    description = "Bringing the elegance of C# EventHanlder to Python";
    license = licenses.bsd3;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
