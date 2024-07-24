{
  lib,
  buildPythonPackage,
  click,
  fetchPypi,
  ipython,
  mock,
  pytestCheckHook,
  pythonOlder,
  sh,
}:

buildPythonPackage rec {
  pname = "python-dotenv";
  version = "1.0.1";
  format = "setuptools";
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4yTukKAj2AjxlZxGvLwERGoQztJ3eD3G7gmYfDfsEMo=";
  };

  propagatedBuildInputs = [ click ];

  nativeCheckInputs = [
    ipython
    mock
    pytestCheckHook
    sh
  ];

  disabledTests = [ "cli" ];

  pythonImportsCheck = [ "dotenv" ];

  meta = with lib; {
    description = "Add .env support to your django/flask apps in development and deployments";
    mainProgram = "dotenv";
    homepage = "https://github.com/theskumar/python-dotenv";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ erikarvstedt ];
  };
}
