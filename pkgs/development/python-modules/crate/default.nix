{ lib
, fetchPypi
, buildPythonPackage
, urllib3
, geojson
, isPy3k
, sqlalchemy
, pytestCheckHook
, stdenv
}:

buildPythonPackage rec {
  pname = "crate";
  version = "0.26.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "6f650c2efe250b89bf35f8fe3211eb37ebc8d76f7a9c09bd73db3076708fa2fc";
  };

  propagatedBuildInputs = [
    urllib3
    sqlalchemy
    geojson
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = lib.optionals stdenv.isDarwin [ "src/crate/client/test_http.py" ];

  meta = with lib; {
    homepage = "https://github.com/crate/crate-python";
    description = "A Python client library for CrateDB";
    license = licenses.asl20;
    maintainers = with maintainers; [ doronbehar ];
  };
}
