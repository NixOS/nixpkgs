{
  lib,
  buildPythonPackage,
  cliff,
  fetchFromGitHub,
  keystoneauth1,
  openstacksdk,
  oslo-i18n,
  oslo-utils,
  pbr,
  requests,
  requests-mock,
  setuptools,
  stdenv,
  stestr,
  stevedore,
}:

buildPythonPackage rec {
  pname = "osc-lib";
  version = "4.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "osc-lib";
    tag = version;
    hash = "sha256-mFZLVlq2mFgx5yQLBPVVT/zDLbOJ/EodAwsm/QxvW0Q=";
  };

  env.PBR_VERSION = version;

  build-system = [
    pbr
    setuptools
  ];

  dependencies = [
    cliff
    keystoneauth1
    openstacksdk
    oslo-i18n
    oslo-utils
    requests
    stevedore
  ];

  nativeCheckInputs = [
    requests-mock
    stestr
  ];

  checkPhase = ''
    stestr run -e <(echo "
    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      osc_lib.tests.test_shell.TestShellCli.test_shell_args_cloud_public
      osc_lib.tests.test_shell.TestShellCli.test_shell_args_precedence
      osc_lib.tests.test_shell.TestShellCliPrecedence.test_shell_args_precedence_1
      osc_lib.tests.test_shell.TestShellCliPrecedence.test_shell_args_precedence_2
    ''}")
  '';

  pythonImportsCheck = [ "osc_lib" ];

  meta = with lib; {
    description = "OpenStackClient Library";
    homepage = "https://github.com/openstack/osc-lib";
    license = licenses.asl20;
    teams = [ teams.openstack ];
  };
}
