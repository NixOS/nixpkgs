{
  lib,
  buildPythonPackage,
  docker,
  fetchFromGitHub,
  keystoneauth1,
  openstackdocstheme,
  osc-lib,
  oslo-i18n,
  oslo-log,
  oslo-utils,
  pbr,
  prettytable,
  pythonOlder,
  setuptools,
  sphinxHook,
  stestr,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "python-zunclient";
  version = "5.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-zunclient";
    tag = version;
    hash = "sha256-qBpsahkVZEQwsVcNJFtRSJvvxGITauAJ6Zv8p+70hh0=";
  };

  env.PBR_VERSION = version;

  build-system = [
    pbr
    setuptools
  ];

  nativeBuildInputs = [
    openstackdocstheme
    sphinxHook
  ];

  sphinxBuilders = [ "man" ];

  # python-openstackclient is unused upstream
  # and will cause infinite recursion in openstackclient-full package.
  pythonRemoveDeps = [ "python-openstackclient" ];

  dependencies = [
    docker
    keystoneauth1
    osc-lib
    oslo-i18n
    oslo-log
    oslo-utils
    prettytable
    websocket-client
  ];

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
    homepage = "https://github.com/openstack/python-zunclient";
    description = "Client library for OpenStack Zun API";
    license = lib.licenses.asl20;
    mainProgram = "zun";
    teams = [ lib.teams.openstack ];
  };
}
