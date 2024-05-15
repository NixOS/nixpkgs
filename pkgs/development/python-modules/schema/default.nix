{ lib
, buildPythonPackage
, fetchPypi
, mock
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "schema";
  version = "0.7.7";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-faVTq9KVihncJUfDiM3lM5izkZYXWpvlnqHK9asKGAc=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRemoveDeps = [
    "contextlib2"
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "schema"
  ];

  meta = with lib; {
    description = "Library for validating Python data structures";
    homepage = "https://github.com/keleshev/schema";
    license = licenses.mit;
    maintainers = with maintainers; [ tobim ];
  };
}
