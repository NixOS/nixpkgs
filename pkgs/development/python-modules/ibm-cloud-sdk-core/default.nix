{ lib
, buildPythonPackage
, fetchPypi
, codecov
, pyjwt
, pylint
, pytestCheckHook
, pytestcov
, python-dateutil
, requests
, responses
, tox
}:

buildPythonPackage rec {
  pname = "ibm-cloud-sdk-core";
  version = "3.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gwx0z6yqlym9af6wnzq5alcrx8pfsywxn18a0yxhm1j00rkyh2i";
  };

  checkInputs = [
    codecov
    pylint
    pytestCheckHook
    pytestcov
    responses
    tox
  ];

  propagatedBuildInputs = [
    pyjwt
    python-dateutil
    requests
  ];

  # Various tests try to access credential files which are not included with the source distribution
  disabledTests = [
    "test_iam" "test_cwd" "test_configure_service" "test_get_authenticator"
    "test_read_external_sources_2" "test_files_duplicate_parts" "test_files_list"
    "test_files_dict" "test_retry_config_external" "test_gzip_compression_external"
  ];

  meta = with lib; {
    description = "Client library for the IBM Cloud services";
    homepage = "https://github.com/IBM/python-sdk-core";
    license = licenses.asl20;
    maintainers = with maintainers; [ globin lheckemann ];
  };
}
