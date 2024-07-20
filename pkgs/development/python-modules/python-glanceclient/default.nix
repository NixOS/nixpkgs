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
  oslo-utils,
  oslo-i18n,
  wrapt,
  pyopenssl,
  pythonOlder,
  stestr,
  testscenarios,
  ddt,
  requests-mock,
  writeText,
}:
let
  pname = "python-glanceclient";
  version = "4.6.0";

  disabledTests = [
    "test_http_chunked_response"
    "test_v1_download_has_no_stray_output_to_stdout"
    "test_v2_requests_valid_cert_verification"
    "test_download_has_no_stray_output_to_stdout"
    "test_v2_download_has_no_stray_output_to_stdout"
    "test_v2_requests_valid_cert_verification_no_compression"
    "test_log_request_id_once"
  ];
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gJm4TzxtIjvkpOlbN82MPbY0JmDdiwlEMGGxZvTR+Po=";
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
    stestr
    testscenarios
    ddt
    requests-mock
  ];

  checkPhase = ''
    runHook preCheck
    stestr run -e ${writeText "disabled-tests" (lib.concatStringsSep "\n" disabledTests)}
    runHook postCheck
  '';

  pythonImportsCheck = [ "glanceclient" ];

  meta = with lib; {
    description = "Python bindings for the OpenStack Images API";
    homepage = "https://github.com/openstack/python-glanceclient/";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
