{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "py-nextbusnext";
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ViViDboarder";
    repo = "py_nextbus";
    rev = "refs/tags/v${version}";
    hash = "sha256-044VDg7bQNNnRGiPZW9gwo3Bzq0LPYKTrd3EgmBOcGA=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "py_nextbus"
  ];

  meta = with lib; {
    description = "Minimalistic Python client for the NextBus public API";
    homepage = "https://github.com/ViViDboarder/py_nextbus";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
