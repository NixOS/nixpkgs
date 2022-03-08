{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, libcst
, mock
, proto-plus
, pytestCheckHook
, pytest-asyncio
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-redis";
  version = "2.7.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tz2upcRjgE6/4cB0riARwot3Vhw4QSKqqHTlJS3i7is=";
  };

  propagatedBuildInputs = [
    google-api-core
    libcst
    proto-plus
  ];

  checkInputs = [
    mock
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "google.cloud.redis"
    "google.cloud.redis_v1"
    "google.cloud.redis_v1beta1"
  ];

  meta = with lib; {
    description = "Google Cloud Memorystore for Redis API client library";
    homepage = "https://github.com/googleapis/python-redis";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
