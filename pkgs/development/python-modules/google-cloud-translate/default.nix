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
}:

buildPythonPackage rec {
  pname = "google-cloud-translate";
  version = "3.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "38772cc60ef4315d25a7dbeef5ddab9e75674722cb4500bc69b295e5d0af6a97";
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
