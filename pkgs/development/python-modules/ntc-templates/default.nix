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
  version = "7.5.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "networktocode";
    repo = "ntc-templates";
    tag = "v${version}";
    hash = "sha256-VRkWjhl/7qDwXTWQ5ZhIS7JMuxJWlWkqwjoSo1DXOQE=";
  };

  build-system = [ poetry-core ];

  propagatedBuildInputs = [ textfsm ];

  nativeCheckInputs = [
    invoke
    pytestCheckHook
    ruamel-yaml
    toml
    yamllint
  ];

  # https://github.com/networktocode/ntc-templates/issues/743
  disabledTests = [
    "test_raw_data_against_mock"
    "test_verify_parsed_and_reference_data_exists"
  ];

  meta = with lib; {
    description = "TextFSM templates for parsing show commands of network devices";
    homepage = "https://github.com/networktocode/ntc-templates";
    changelog = "https://github.com/networktocode/ntc-templates/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
