{ lib
, buildPythonPackage
, fetchPypi
, pbr
, sentinels
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mongomock";
  version = "3.23.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pdh4pj5n6dsaqy98q40wig5y6imfs1p043cgkaaw8f2hxy5x56r";
  };

  nativeBuildInputs = [
    pbr
  ];

  propagatedBuildInputs = [
    sentinels
    six
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "mongomock" ];

  meta = with lib; {
    homepage = "https://github.com/mongomock/mongomock";
    description = "Fake pymongo stub for testing simple MongoDB-dependent code";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gador ];
  };
}
