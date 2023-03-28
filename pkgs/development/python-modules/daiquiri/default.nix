{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, python-json-logger
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "daiquiri";
  version = "3.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QIxNKOyPDqI+llN0R5gpvSI2TQwI15HL63u6JFlj4P0=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    python-json-logger
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "daiquiri" ];

  meta = with lib; {
    description = "Library to configure Python logging easily";
    homepage = "https://github.com/Mergifyio/daiquiri";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
