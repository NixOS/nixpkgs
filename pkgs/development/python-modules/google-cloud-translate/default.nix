{ stdenv
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, google-api-core
, google-cloud-core
, google-cloud-testutils
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

  propagatedBuildInputs = [ google-api-core google-cloud-core libcst proto-plus ];

  checkInputs = [ google-cloud-testutils mock pytestCheckHook pytest-asyncio ];

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
