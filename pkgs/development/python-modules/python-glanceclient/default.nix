{
  lib,
  buildPythonPackage,
  fetchPypi,
  coreutils,
  setuptools,
  pbr,
  prettytable,
  keystoneauth1,
  requests,
  warlock,
  openstacksdk,
  oslo-i18n,
  oslo-utils,
  wrapt,
  pyopenssl,
  stestrCheckHook,
  testscenarios,
  ddt,
  requests-mock,
}:
let
  pname = "python-glanceclient";
  version = "4.13.0";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    pname = "python_glanceclient";
    inherit version;
    hash = "sha256-+jNZvIvZPnrryjctr+yOGQA7TB9kSZ4uuCsncdqPpBw=";
  };

  postPatch = ''
    substituteInPlace glanceclient/tests/unit/v1/test_shell.py \
      --replace-fail "/bin/echo" "${lib.getExe' coreutils "echo"}"
  '';

  nativeBuildInputs = [ setuptools ];

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
    ddt
    openstacksdk
    requests-mock
    stestrCheckHook
    testscenarios
  ];

  # Skip tests which require networking.
  disabledTests = [
    "glanceclient.tests.unit.test_http.TestClient.test_http_chunked_response"
    "glanceclient.tests.unit.test_http.TestClient.test_log_request_id_once"
  ];

  disabledTestsRegex = [
    ''glanceclient\.tests\.unit\.test_ssl\.TestHTTPSVerifyCert\..*''
  ];

  pythonImportsCheck = [ "glanceclient" ];

  meta = {
    description = "Python bindings for the OpenStack Images API";
    homepage = "https://github.com/openstack/python-glanceclient/";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
