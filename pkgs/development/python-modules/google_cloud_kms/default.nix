{ stdenv, buildPythonPackage, fetchPypi, pytestCheckHook, pythonOlder
, grpc_google_iam_v1, google_api_core, libcst, mock, proto-plus, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "google-cloud-kms";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f3k2ixp1zsgydpvkj75bs2mb805389snyw30hn41c38qq5ksdga";
  };

  disabled = pythonOlder "3.6";

  checkInputs = [ mock pytestCheckHook pytest-asyncio ];
  propagatedBuildInputs =
    [ grpc_google_iam_v1 google_api_core libcst proto-plus ];

  # Disable tests that need credentials
  disabledTests = [ "test_list_global_key_rings" ];

  meta = with stdenv.lib; {
    description = "Cloud Key Management Service (KMS) API API client library";
    homepage = "https://github.com/googleapis/python-kms";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
