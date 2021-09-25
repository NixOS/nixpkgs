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
  version = "0.19.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f521bc2ac9a8e03c736f62911605c5d83970021e3fa95b37d769e2bbbe9b6172";
  };

  propagatedBuildInputs = [ click ];

  checkInputs = [
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
    maintainers = with maintainers; [ earvstedt ];
  };
}
