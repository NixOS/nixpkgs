{ lib
, buildPythonPackage
, fetchPypi
, packaging
, pbr
, pytestCheckHook
, pythonOlder
, sentinels
}:

buildPythonPackage rec {
  pname = "mongomock";
  version = "4.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8GzWKvuK4+9jujE0mr0iCmV+8N1PAkOilYfFIT+TG30=";
  };

  nativeBuildInputs = [
    pbr
  ];

  propagatedBuildInputs = [
    packaging
    sentinels
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mongomock"
  ];

  meta = with lib; {
    homepage = "https://github.com/mongomock/mongomock";
    description = "Fake pymongo stub for testing simple MongoDB-dependent code";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gador ];
  };
}
