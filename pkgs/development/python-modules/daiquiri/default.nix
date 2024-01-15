{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, python-json-logger
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "daiquiri";
  version = "3.2.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-P8rvN2/WgIi5I5E3R6t+4S2Lf7Kvf4xfIOWYCZfp6DU=";
  };

  nativeBuildInputs = [
    setuptools
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
