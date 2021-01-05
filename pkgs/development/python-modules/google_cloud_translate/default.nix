{ stdenv
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, google_api_core
, google_cloud_core
, google_cloud_testutils
, grpcio
, libcst
, mock
, proto-plus
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "google-cloud-translate";
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1s2gvlzfqd2gsrzaz7yl9q8s1k03dlsjahgg95s017vlcn21d0v1";
  };

  propagatedBuildInputs = [ google_api_core google_cloud_core libcst proto-plus ];

  checkInputs = [ google_cloud_testutils mock pytestCheckHook pytest-asyncio ];

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

  meta = with stdenv.lib; {
    description = "Google Cloud Translation API client library";
    homepage = "https://github.com/googleapis/python-translate";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
