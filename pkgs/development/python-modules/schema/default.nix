{
  lib,
  buildPythonPackage,
  fetchPypi,
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "schema";
  version = "0.7.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-faVTq9KVihncJUfDiM3lM5izkZYXWpvlnqHK9asKGAc=";
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
