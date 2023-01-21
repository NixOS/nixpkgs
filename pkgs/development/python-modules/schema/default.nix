{ lib
, buildPythonPackage
, contextlib2
, fetchPypi
, mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "schema";
  version = "0.7.5";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8GcXESxhiVyrxHB3UriHFuhCCogZ1xQEUB4RT5EEMZc=";
  };

  propagatedBuildInputs = [
    contextlib2
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
