{
  lib,
  attrs,
  buildPythonPackage,
  dnspython,
  fetchFromGitHub,
  hatchling,
  hier-config,
  loguru,
  macaddress,
  passlib,
  pyparsing,
  pytest-cov-stub,
  pytestCheckHook,
  pyyaml,
  rich,
  scrypt,
  tomlkit,
  typeguard,
}:

buildPythonPackage rec {
  pname = "ciscoconfparse2";
  version = "0.8.17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mpenning";
    repo = "ciscoconfparse2";
    tag = version;
    hash = "sha256-G6FR2v/FJE0ySpNXJ9603O16UjSqOkRB2+7xNoLBJAM=";
  };

  pythonRelaxDeps = [
    "attrs"
    "hier-config"
    "passlib"
    "tomlkit"
    "typeguard"
  ];

  build-system = [ hatchling ];

  dependencies = [
    attrs
    dnspython
    hier-config
    loguru
    macaddress
    passlib
    pyparsing
    pyyaml
    rich
    scrypt
    tomlkit
    typeguard
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ciscoconfparse2" ];

  disabledTests = [
    # Fixtures are missing
    "testParse_parse_syntax"
    "testParse_syntax"
    "testVal_IOSHSRPGroups"
    "testVal_IOSSDWAN"
    "testVal_junos_factory"
    "testVal_JunosCfgLine"
    "testValues_ccp_script_entry_cliapplication"
    "testValues_Diff"
    "testValues_IOSCfgLine"
    "testValues_pickle"
    "testValues_save_as_01"
  ];

  meta = {
    description = "Module to parse, audit, query, build and modify device configurations";
    homepage = "https://github.com/mpenning/ciscoconfparse2";
    changelog = "https://github.com/mpenning/ciscoconfparse2/blob/${src.tag}/CHANGES.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
