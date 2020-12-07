{ stdenv, buildPythonPackage, fetchPypi, pythonOlder, grpc_google_iam_v1
, google_api_core, google-cloud-access-context-manager, google-cloud-org-policy
, libcst, proto-plus, pytest, pytest-asyncio, pytestCheckHook, mock }:

buildPythonPackage rec {
  pname = "google-cloud-asset";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cf1b8a102eea8cec65eb07bef51dc15c1136cfc8564ea7fc5a39465b8f20017";
  };

  disabled = pythonOlder "3.6";

  checkInputs = [ mock pytest-asyncio pytestCheckHook ];
  disabledTests = [ "asset_service_transport_auth_adc" ];
  propagatedBuildInputs = [
    grpc_google_iam_v1
    google_api_core
    google-cloud-access-context-manager
    google-cloud-org-policy
    libcst
    proto-plus
  ];

  # Remove tests intended to be run in VPC
  preCheck = ''
    rm -rf tests/system
  '';

  meta = with stdenv.lib; {
    description = "Python Client for Google Cloud Asset API";
    homepage = "https://github.com/googleapis/python-asset";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
