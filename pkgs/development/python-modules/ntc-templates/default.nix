{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, poetry-core
, textfsm
, pytestCheckHook
, ruamel-yaml
, yamllint
}:

buildPythonPackage rec {
  pname = "ntc-templates";
  version = "3.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "networktocode";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-FhKMDSAW+MifAy2EnHePbSfY56rdK1SfOe85bFte6ps=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    textfsm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    ruamel-yaml
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
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
