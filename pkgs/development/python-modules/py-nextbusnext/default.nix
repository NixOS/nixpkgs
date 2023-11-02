{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "py-nextbusnext";
  version = "1.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ViViDboarder";
    repo = "py_nextbus";
    rev = "refs/tags/v${version}";
    hash = "sha256-iJPbRhXgA1AIkyf3zGZ9tuFAw8h6oyBbh7Ln/y72fyQ=";
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
