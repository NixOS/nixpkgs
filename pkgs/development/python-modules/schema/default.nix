{
  lib,
  buildPythonPackage,
  fetchPypi,
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "schema";
  version = "0.7.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6GzAjt1v5uJSJkj05H46MZIKdugszok3U1Qi4xCGKrU=";
  };

  pythonRemoveDeps = [ "contextlib2" ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "schema" ];

  meta = {
    description = "Library for validating Python data structures";
    homepage = "https://github.com/keleshev/schema";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tobim ];
  };
}
