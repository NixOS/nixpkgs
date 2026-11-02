{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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

buildPythonPackage (finalAttrs: {
  pname = "python-glanceclient";
  version = "4.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-glanceclient";
    tag = finalAttrs.version;
    hash = "sha256-5KwZ5XVosCUFObXaraVPWOO6ZdeMYWO+n2IsUwojFJg=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

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
})
