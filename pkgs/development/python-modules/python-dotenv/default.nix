{ lib
, buildPythonPackage
, click
, fetchPypi
, ipython
, mock
, pytestCheckHook
, pythonOlder
, sh
}:

buildPythonPackage rec {
  pname = "python-dotenv";
  version = "1.0.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qN+WA0qubS1QpOvoIWMmxhw+tkg2d2UE/MpBDlk3o7o=";
  };

  propagatedBuildInputs = [ click ];

  nativeCheckInputs = [
    ipython
    mock
    pytestCheckHook
    sh
  ];

  disabledTests = [
    "cli"
  ];

  pythonImportsCheck = [ "dotenv" ];

  meta = with lib; {
    description = "Add .env support to your django/flask apps in development and deployments";
    homepage = "https://github.com/theskumar/python-dotenv";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ erikarvstedt ];
  };
}
