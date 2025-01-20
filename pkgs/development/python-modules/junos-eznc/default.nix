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
  pythonOlder,
  pyyaml,
  scp,
  setuptools,
  pytestCheckHook,
  six,
  transitions,
  yamlordereddictloader,
}:

buildPythonPackage rec {
  pname = "junos-eznc";
  version = "2.7.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Juniper";
    repo = "py-junos-eznc";
    tag = version;
    hash = "sha256-2Y4Zwmf+154t+ul4qE++lunsK5DmdMAVWxV6kMa//D0=";
  };

  build-system = [ setuptools ];

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
    yamlordereddictloader
  ];

  nativeCheckInputs = [
    mock
    nose2
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests/unit" ];

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

  meta = with lib; {
    description = "Junos 'EZ' automation for non-programmers";
    homepage = "https://github.com/Juniper/py-junos-eznc";
    changelog = "https://github.com/Juniper/py-junos-eznc/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ xnaveira ];
  };
}
