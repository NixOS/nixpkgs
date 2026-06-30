{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jinja2,
  lxml,
  mock,
  ncclient,
  netaddr,
  nose2,
  ntc-templates,
  paramiko,
  pyparsing,
  pyserial,
  pyyaml,
  scp,
  setuptools,
  pytestCheckHook,
  six,
  transitions,
  yamlloader,
}:

buildPythonPackage rec {
  pname = "junos-eznc";
  version = "2.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Juniper";
    repo = "py-junos-eznc";
    tag = version;
    hash = "sha256-bRT4WsZVoXtSGMCq+FHHtL454pPVKb7Wc9dMqzYHcgU=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "ncclient" ];

  dependencies = [
    jinja2
    lxml
    ncclient
    netaddr
    ntc-templates
    paramiko
    pyparsing
    pyserial
    pyyaml
    scp
    six
    transitions
    yamlloader
  ];

  nativeCheckInputs = [
    mock
    nose2
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests/unit" ];

  disabledTests = [
    # jnpr.junos.exception.FactLoopError: A loop was detected while gathering the...
    "TestPersonality"
    "TestGetSoftwareInformation"
    "TestIfdStyle"
    # KeyError: 'mac'
    "test_textfsm_table_mutli_key"
    # AssertionError: None != 'juniper.net'
    "test_domain_fact_from_config"
  ];

  pythonImportsCheck = [ "jnpr.junos" ];

  meta = {
    description = "Junos 'EZ' automation for non-programmers";
    homepage = "https://github.com/Juniper/py-junos-eznc";
    changelog = "https://github.com/Juniper/py-junos-eznc/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ xnaveira ];
  };
}
