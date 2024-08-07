{
  lib,
  buildPythonPackage,
  docker,
  fetchFromGitea,
  keystoneauth1,
  openstackdocstheme,
  osc-lib,
  oslo-i18n,
  oslo-log,
  oslo-serialization,
  oslo-utils,
  pbr,
  pythonOlder,
  setuptools,
  sphinxHook,
  stestr,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "python-zunclient";
  version = "5.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitea {
    domain = "opendev.org";
    owner = "openstack";
    repo = "python-zunclient";
    rev = version;
    hash = "sha256-EVfrxSc/eHYZR0FGFnNAxFCiXangt8uRkAC2zpwWqcA=";
  };

  env.PBR_VERSION = version;

  build-system = [
    openstackdocstheme
    pbr
    setuptools
    sphinxHook
  ];

  sphinxBuilders = [ "man" ];

  # python-openstackclient is unused upstream
  # and will cause infinite recursion in openstackclient-full package.
  #
  pythonRemoveDeps = [ "python-openstackclient" ];

  dependencies = [
    docker
    keystoneauth1
    osc-lib
    oslo-i18n
    oslo-log
    oslo-serialization
    oslo-utils
    websocket-client
  ];

  doCheck = true;

  nativeCheckInputs = [ stestr ];

  checkPhase = ''
    runHook preCheck
    stestr run -e <(echo "
      zunclient.tests.unit.test_shell.ShellTest.test_main_endpoint_internal
      zunclient.tests.unit.test_shell.ShellTest.test_main_endpoint_public
      zunclient.tests.unit.test_shell.ShellTest.test_main_env_region
      zunclient.tests.unit.test_shell.ShellTest.test_main_no_region
      zunclient.tests.unit.test_shell.ShellTest.test_main_option_region
      zunclient.tests.unit.test_shell.ShellTestKeystoneV3.test_main_endpoint_internal
      zunclient.tests.unit.test_shell.ShellTestKeystoneV3.test_main_endpoint_public
      zunclient.tests.unit.test_shell.ShellTestKeystoneV3.test_main_env_region
      zunclient.tests.unit.test_shell.ShellTestKeystoneV3.test_main_no_region
      zunclient.tests.unit.test_shell.ShellTestKeystoneV3.test_main_option_region
    ")
    runHook postCheck
  '';

  pythonImportsCheck = [ "zunclient" ];

  meta = {
    homepage = "https://opendev.org/openstack/python-zunclient";
    description = "Client library for OpenStack Zun API";
    license = lib.licenses.asl20;
    mainProgram = "zun";
    maintainers = lib.teams.openstack.members;
  };
}
