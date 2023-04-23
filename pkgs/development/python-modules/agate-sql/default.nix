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
  version = "0.5.9";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MLZCoypbZxFhq++ejsNjUvLniiTOhJBU7axpRti53cY=";
  };

  propagatedBuildInputs = [ agate sqlalchemy ];

  nativeCheckInputs = [ crate geojson pytestCheckHook ];

  pythonImportsCheck = [ "agatesql" ];

  meta = with lib; {
    # https://github.com/wireservice/agate-sql/commit/74af1badd85408909ea72cb6ca8c0b223d178c6f
    broken = lib.versionAtLeast sqlalchemy.version "2.0";
    description = "Adds SQL read/write support to agate.";
    homepage = "https://github.com/wireservice/agate-sql";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ vrthra ];
  };
}
