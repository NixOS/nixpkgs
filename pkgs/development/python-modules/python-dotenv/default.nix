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
  version = "0.21.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-t30IJ0Y549NBRd+mxwCOZt8PBLe+enX9DVKSwZHXkEU=";
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
