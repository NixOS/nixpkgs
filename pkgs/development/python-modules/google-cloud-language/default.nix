{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, libcst
, mock
, proto-plus
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "google-cloud-language";
  version = "2.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "90af7858911f52350191575bb729305114c3c80d1f585d0f6cea39ab1ab3e409";
  };

  propagatedBuildInputs = [ google-api-core libcst proto-plus ];

  checkInputs = [ mock pytestCheckHook pytest-asyncio ];

  pythonImportsCheck = [
    "google.cloud.language"
    "google.cloud.language_v1"
    "google.cloud.language_v1beta2"
  ];

  meta = with lib; {
    description = "Google Cloud Natural Language API client library";
    homepage = "https://github.com/googleapis/python-language";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
