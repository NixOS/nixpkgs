{ lib
, buildPythonPackage
, cymem
, cython
, python
, fetchPypi
, murmurhash
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "preshed";
  version = "4.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XisLKgfdGo3uqtZhIBmEXGAu4kkH9pNuqvF6q9VuVEw=";
  };

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    cymem
    murmurhash
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Tests have import issues with 3.0.8
  doCheck = false;

  pythonImportsCheck = [
    "preshed"
  ];

  meta = with lib; {
    description = "Cython hash tables that assume keys are pre-hashed";
    homepage = "https://github.com/explosion/preshed";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
