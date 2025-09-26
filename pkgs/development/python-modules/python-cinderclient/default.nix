{
  lib,
  buildPythonPackage,
  fetchPypi,
  ddt,
  keystoneauth1,
  openstackdocstheme,
  oslo-i18n,
  oslo-serialization,
  oslo-utils,
  pbr,
  requests,
  prettytable,
  pythonOlder,
  reno,
  requests-mock,
  setuptools,
  simplejson,
  sphinxHook,
  stestr,
  stevedore,
}:

buildPythonPackage rec {
  pname = "python-cinderclient";
  version = "9.8.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "python_cinderclient";
    inherit version;
    hash = "sha256-vT7p+Uh8XnmVfwGKaz8t7OcFna2PYVXYPdS265RHoR0=";
  };

  nativeBuildInputs = [
    openstackdocstheme
    reno
    sphinxHook
  ];

  sphinxBuilders = [ "man" ];

  build-system = [ setuptools ];

  dependencies = [
    simplejson
    keystoneauth1
    oslo-i18n
    oslo-utils
    pbr
    prettytable
    requests
    stevedore
  ];

  nativeCheckInputs = [
    ddt
    oslo-serialization
    requests-mock
    stestr
  ];

  checkPhase = ''
    runHook preCheck

    #   File "/build/python-cinderclient-9.6.0/cinderclient/client.py", line 196, in request
    # if raise_exc and resp.status_code >= 400:
    #                  ^^^^^^^^^^^^^^^^^^^^^^^
    #
    # TypeError: '>=' not supported between instances of 'Mock' and 'int'
    stestr run -e <(echo "
      cinderclient.tests.unit.test_client.ClientTest.test_keystone_request_raises_auth_failure_exception
      cinderclient.tests.unit.test_client.ClientTest.test_sessionclient_request_method
      cinderclient.tests.unit.test_client.ClientTest.test_sessionclient_request_method_raises_badrequest
      cinderclient.tests.unit.test_client.ClientTest.test_sessionclient_request_method_raises_overlimit
      cinderclient.tests.unit.test_shell.ShellTest.test_password_prompted
      cinderclient.tests.unit.test_shell.TestLoadVersionedActions.test_load_versioned_actions_with_help
    ")

    runHook postCheck
  '';

  pythonImportsCheck = [ "cinderclient" ];

  meta = with lib; {
    description = "OpenStack Block Storage API Client Library";
    mainProgram = "cinder";
    homepage = "https://github.com/openstack/python-cinderclient";
    license = licenses.asl20;
    teams = [ teams.openstack ];
  };
}
