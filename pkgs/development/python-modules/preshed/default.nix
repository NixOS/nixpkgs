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
  version = "3.0.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bHTHAHiAm/3doXvpZIPEHQbXF5NLB8q3khAR2BdYs1c=";
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
