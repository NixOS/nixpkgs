{ lib
, buildPythonPackage
, isPy27
, fetchPypi
, agate
, sqlalchemy
, crate
, nose
, geojson
}:

buildPythonPackage rec {
  pname = "agate-sql";
  version = "0.5.7";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "7622c1f243b5a9a5efddfe28c36eeeb30081e43e3eb72e8f3da22c2edaecf4d8";
  };

  propagatedBuildInputs = [ agate sqlalchemy ];

  # crate is broken in nixpkgs, with SQLAlchemy > 1.3
  # Skip tests for now as they rely on it.
  doCheck = false;

  checkInputs = [ crate nose geojson ];

  checkPhase = ''
    nosetests
  '';

  pythonImportsCheck = [ "agatesql" ];

  meta = with lib; {
    description = "Adds SQL read/write support to agate.";
    homepage = "https://github.com/wireservice/agate-sql";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ vrthra ];
  };
}
