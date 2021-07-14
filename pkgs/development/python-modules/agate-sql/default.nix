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
  version = "0.5.6";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "056dc9e587fbdfdf3f1c9950f4793a5ee87622c19deba31aa0a6d6681816dcde";
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
