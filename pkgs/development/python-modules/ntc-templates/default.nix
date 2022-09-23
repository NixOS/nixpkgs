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
  version = "3.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "networktocode";
    repo = pname;
    rev = "v${version}";
    sha256 = "0kijzmmvq2rw7ima19w7lyb2p26a5w52k70fzbkaqqw78qzw8178";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    textfsm
  ];

  checkInputs = [
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
