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
  version = "0.5.8";

  disabled = isPy27;

  src = fetchFromGitHub {
     owner = "wireservice";
     repo = "agate-sql";
     rev = "0.5.8";
     sha256 = "1l9mnm5jifxp69v9qdfh1lw2j093jancj6v37hvsmn8x3qr64h00";
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
