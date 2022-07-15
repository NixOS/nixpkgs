{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, google-api-core
, google-cloud-core
, google-cloud-testutils
, libcst
, mock
, proto-plus
, pytest-asyncio
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-translate";
  version = "3.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xdnMOy1JkmNnC+seLsxJp+Oq2G3oGXsKHS3//Bzfgq8=";
  };

  propagatedBuildInputs = [
    google-api-core
    google-cloud-core
    libcst
    proto-plus
  ];

  checkInputs = [
    google-cloud-testutils
    mock
    pytestCheckHook
    pytest-asyncio
  ];

  preCheck = ''
    # prevent shadowing imports
    rm -r google
  '';

  pythonImportsCheck = [
    "google.cloud.translate"
    "google.cloud.translate_v2"
    "google.cloud.translate_v3"
    "google.cloud.translate_v3beta1"
  ];

  meta = with lib; {
    description = "Google Cloud Translation API client library";
    homepage = "https://github.com/googleapis/python-translate";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
