{ lib
, buildPythonPackage
, fetchPypi
, coreutils
, pbr
, prettytable
, keystoneauth1
, requests
, warlock
, oslo-utils
, oslo-i18n
, wrapt
, pyopenssl
, pythonOlder
, stestrCheckHook
, testscenarios
, ddt
, requests-mock
, libredirect
, iana-etc
}:

buildPythonPackage rec {
  pname = "python-glanceclient";
  version = "4.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ejZuH/Zr23bmJ+7PfNQFO9lPNfo83GkNKa/0fpduBTI=";
  };

  postPatch = ''
    substituteInPlace glanceclient/tests/unit/v1/test_shell.py \
      --replace "/bin/echo" "${coreutils}/bin/echo"
  '';

  propagatedBuildInputs = [
    pbr
    prettytable
    keystoneauth1
    requests
    warlock
    oslo-utils
    oslo-i18n
    wrapt
    pyopenssl
  ];

  nativeCheckInputs = [
    stestrCheckHook
    testscenarios
    ddt
    requests-mock
  ];

  pythonImportsCheck = [
    "glanceclient"
  ];

  disabledTests = [
    "glanceclient.tests.unit.test_ssl.TestHTTPSVerifyCert.test_v2_requests_valid_cert_verification"
    "glanceclient.tests.unit.test_ssl.TestHTTPSVerifyCert.test_v2_requests_valid_cert_verification_no_compression"
    "glanceclient.tests.unit.test_http.TestClient.test_http_chunked_response"
    "glanceclient.tests.unit.test_http.TestClient.test_log_request_id_once"
  ];

  meta = with lib; {
    description = "Python bindings for the OpenStack Images API";
    homepage = "https://github.com/openstack/python-glanceclient/";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
