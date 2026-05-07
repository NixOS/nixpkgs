{
  lib,
  buildPythonPackage,
  cliff,
  fetchFromGitHub,
  iso8601,
  keystoneauth1,
  openstackdocstheme,
  osc-lib,
  oslo-i18n,
  oslo-serialization,
  oslo-utils,
  pbr,
  prettytable,
  python-openstackclient,
  python-swiftclient,
  pyyaml,
  requests-mock,
  requests,
  setuptools,
  sphinxHook,
  stestrCheckHook,
  testscenarios,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-heatclient";
  version = "5.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-heatclient";
    tag = finalAttrs.version;
    hash = "sha256-KUFpFqjFtuF9VFQ0Fn9oVQSpwsocZhKY6vWtqpefUJs=";
  };

  env.PBR_VERSION = finalAttrs.version;

  build-system = [
    openstackdocstheme
    python-openstackclient
    setuptools
    pbr
    sphinxHook
  ];

  sphinxBuilders = [ "man" ];

  dependencies = [
    cliff
    iso8601
    keystoneauth1
    osc-lib
    oslo-i18n
    oslo-serialization
    oslo-utils
    prettytable
    python-swiftclient
    pyyaml
    requests
  ];

  nativeCheckInputs = [
    stestrCheckHook
    testscenarios
    requests-mock
  ];

  # These tests are failing on Python 3.14 because request.pathname2url fails to add // after the protocol's name.
  # https://github.com/NixOS/nixpkgs/pull/488828#:~:text=discuss%2Epython%2Eorg%2Ft%2Fpathname2url%2Dchanges%2Din%2Dpython%2D3%2D14%2Dbreaking%2Dpip%2Dtests%2F97091
  disabledTests = [
    "heatclient.tests.unit.test_shell.ShellTestConfig.test_config_create"
    "heatclient.tests.unit.test_shell.ShellTestStandaloneToken.test_stack_create_param_file"
    "heatclient.tests.unit.test_shell.ShellTestStandaloneToken.test_stack_create_only_param_file"
    "heatclient.tests.unit.test_shell.ShellTestToken.test_stack_create_only_param_file"
    "heatclient.tests.unit.test_shell.ShellTestToken.test_stack_create_param_file"
    "heatclient.tests.unit.test_shell.ShellTestUserPass.test_stack_create_param_file"
    "heatclient.tests.unit.test_shell.ShellTestUserPass.test_stack_create_only_param_file"
    "heatclient.tests.unit.test_shell.ShellTestUserPassKeystoneV3.test_stack_create_param_file"
    "heatclient.tests.unit.test_shell.ShellTestUserPassKeystoneV3.test_stack_create_only_param_file"
    "heatclient.tests.unit.test_template_utils.TestTemplateGetFileFunctions.test_hot_template"
    "heatclient.tests.unit.test_template_utils.TestTemplateGetFileFunctions.test_hot_template_same_file"
    "heatclient.tests.unit.test_template_utils.TestTemplateGetFileFunctions.test_hot_template_outputs"
    "heatclient.tests.unit.test_template_utils.ShellEnvironmentTest.test_process_multiple_environments_empty_registry"
    "heatclient.tests.unit.test_template_utils.ShellEnvironmentTest.test_process_multiple_environments_default_resources"
    "heatclient.tests.unit.test_template_utils.ShellEnvironmentTest.test_ignore_env_keys"
    "heatclient.tests.unit.test_template_utils.ShellEnvironmentTest.test_process_multiple_environments_and_files"
    "heatclient.tests.unit.test_template_utils.ShellEnvironmentTest.test_process_environment_empty_file"
    "heatclient.tests.unit.test_template_utils.ShellEnvironmentTest.test_process_environment_file"
    "heatclient.tests.unit.test_template_utils.ShellEnvironmentTest.test_process_environment_relative_file"
    "heatclient.tests.unit.test_template_utils.ShellEnvironmentTest.test_process_environment_relative_file_up"
    "heatclient.tests.unit.test_template_utils.ShellEnvironmentTest.test_process_environment_relative_file_tracker"
    "heatclient.tests.unit.test_template_utils.ShellEnvironmentTest.test_process_multiple_environments_and_files_tracker"
    "heatclient.tests.unit.test_template_utils.TestTemplateTypeFunctions.test_hot_template"
    "heatclient.tests.unit.test_template_utils.TestGetTemplateContents.test_get_template_contents_parse_error"
    "heatclient.tests.unit.test_template_utils.TestGetTemplateContents.test_get_template_contents_file_empty"
    "heatclient.tests.unit.test_template_utils.TestNestedIncludes.test_env_nested_includes"
    "heatclient.tests.unit.test_template_utils.TestTemplateInFileFunctions.test_hot_template"
    "heatclient.tests.unit.test_utils.TestURLFunctions.test_get_template_url"
    "heatclient.tests.unit.test_utils.TestURLFunctions.test_normalise_file_path_to_url_absolute"
    "heatclient.tests.unit.test_utils.TestURLFunctions.test_normalise_file_path_to_url_relative"
  ];

  pythonImportsCheck = [
    "heatclient"
    "heatclient.client"
    "heatclient.common"
    "heatclient.osc"
    "heatclient.osc.v1"
    "heatclient.tests"
    "heatclient.tests.unit"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "OpenStack Heat Client and bindings";
    mainProgram = "heat";
    homepage = "https://docs.openstack.org/python-heatclient/latest/";
    downloadPage = "https://github.com/openstack/python-heatclient/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
