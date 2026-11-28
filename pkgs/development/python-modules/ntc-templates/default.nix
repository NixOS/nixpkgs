{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
  version = "9.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "networktocode";
    repo = "ntc-templates";
    tag = "v${version}";
    hash = "sha256-lBzn6ZSjd8Vrpb9vHIH/joSSjwSNIRHBMDhrIyx+QzY=";
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

  meta = {
    description = "TextFSM templates for parsing show commands of network devices";
    homepage = "https://github.com/networktocode/ntc-templates";
    changelog = "https://github.com/networktocode/ntc-templates/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
