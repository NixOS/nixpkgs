{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  poetry-core,
  textfsm,
  invoke,
  pytestCheckHook,
  ruamel-yaml,
  toml,
  yamllint,
}:

buildPythonPackage rec {
  pname = "ntc-templates";
  version = "7.9.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "networktocode";
    repo = "ntc-templates";
    tag = "v${version}";
    hash = "sha256-ujWPcVqwdtMlCkTZP/PJ3oMR60F6IHrZXXhcNT7JmmM=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [ "textfsm" ];

  dependencies = [ textfsm ];

  nativeCheckInputs = [
    invoke
    pytestCheckHook
    ruamel-yaml
    toml
    yamllint
  ];

  meta = with lib; {
    description = "TextFSM templates for parsing show commands of network devices";
    homepage = "https://github.com/networktocode/ntc-templates";
    changelog = "https://github.com/networktocode/ntc-templates/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
