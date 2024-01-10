{ lib
, buildPythonPackage
, isPy27
, fetchPypi
, agate
, sqlalchemy
, crate
, pytestCheckHook
, geojson
}:

buildPythonPackage rec {
  pname = "agate-sql";
  version = "0.7.0";
  format = "setuptools";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uyHkkc3KzuYulOtod9KkHQmszVh2mrrCOLwvQt6JTMk=";
  };

  propagatedBuildInputs = [ agate sqlalchemy ];

  nativeCheckInputs = [ crate geojson pytestCheckHook ];

  pythonImportsCheck = [ "agatesql" ];

  meta = with lib; {
    description = "Adds SQL read/write support to agate.";
    homepage = "https://github.com/wireservice/agate-sql";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ vrthra ];
  };
}
