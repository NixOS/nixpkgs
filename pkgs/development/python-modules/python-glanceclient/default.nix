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
  stestr,
  testscenarios,
  ddt,
  requests-mock,
  writeText,
}:
let
  pname = "python-glanceclient";
  version = "4.10.0";

  disabledTests = [
    # Skip tests which require networking.
    "test_http_chunked_response"
    "test_v1_download_has_no_stray_output_to_stdout"
    "test_v2_requests_valid_cert_verification"
    "test_download_has_no_stray_output_to_stdout"
    "test_v1_requests_cert_verification_no_compression"
    "test_v1_requests_cert_verification"
    "test_v2_download_has_no_stray_output_to_stdout"
    "test_v2_requests_bad_ca"
    "test_v2_requests_bad_cert"
    "test_v2_requests_cert_verification_no_compression"
    "test_v2_requests_cert_verification"
    "test_v2_requests_valid_cert_no_key"
    "test_v2_requests_valid_cert_verification_no_compression"
    "test_log_request_id_once"
    # asserts exact amount of mock calls
    "test_cache_schemas_gets_when_forced"
    "test_cache_schemas_gets_when_not_exists"
  ];
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    pname = "python_glanceclient";
    inherit version;
    hash = "sha256-/2wtQqF2fFz6PNHSKjcy04qxE9RxrSLE7mShvTlBsQM=";
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
    teams = [ teams.openstack ];
  };
}
