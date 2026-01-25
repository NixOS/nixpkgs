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
  pythonAtLeast,
  requests,
  requests-mock,
  setuptools,
  stdenv,
  stestr,
  stevedore,
  writeText,
}:

buildPythonPackage rec {
  pname = "osc-lib";
  version = "4.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "osc-lib";
    tag = version;
    hash = "sha256-1mMON/aVJon7t/zfYVhFpuB78b+DmOEVhvIFaTBRqfo=";
  };

  postPatch = ''
    # TODO: somehow bring this to upstreams attention
    substituteInPlace pyproject.toml \
      --replace-fail '"osc_lib"' '"osc_lib", "osc_lib.api", "osc_lib.cli", "osc_lib.command", "osc_lib.test", "osc_lib.tests", "osc_lib.tests.api", "osc_lib.tests.cli", "osc_lib.tests.command", "osc_lib.tests.utils", "osc_lib.utils"'
  '';

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

  checkPhase =
    let
      disabledTests =
        lib.optionals stdenv.hostPlatform.isDarwin [
          "osc_lib.tests.test_shell.TestShellCli.test_shell_args_cloud_public"
          "osc_lib.tests.test_shell.TestShellCli.test_shell_args_precedence"
          "osc_lib.tests.test_shell.TestShellCliPrecedence.test_shell_args_precedence_1"
          "osc_lib.tests.test_shell.TestShellCliPrecedence.test_shell_args_precedence_2"
        ]
        ++ lib.optionals (pythonAtLeast "3.14") [
          # Disable test incompatible with Python 3.14+
          # See upstream issue: https://bugs.launchpad.net/python-openstackclient/+bug/2138684
          "osc_lib.tests.utils.test_tags.TestTagHelps"
        ];
    in
    ''
      runHook preCheck
      stestr run -e <(echo "${lib.concatStringsSep "\n" disabledTests}")
      runHook postCheck
    '';

  pythonImportsCheck = [ "osc_lib" ];

  meta = {
    description = "OpenStackClient Library";
    homepage = "https://github.com/openstack/osc-lib";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
