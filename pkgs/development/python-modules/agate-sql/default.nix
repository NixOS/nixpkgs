{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
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

  src = fetchFromGitHub {
    owner = "wireservice";
    repo = "agate-sql";
    rev = version;
    sha256 = "16rijcnvxrvw9mmyk4228dalrr2qb74y649g1l6qifiabx5ij78s";
  };

  propagatedBuildInputs = [ agate sqlalchemy ];

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
