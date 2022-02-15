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
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-sYMsN0jUdETBiGc3PlzqdUwub2RKDPv9Zn8Xj2i97Pw=";
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
