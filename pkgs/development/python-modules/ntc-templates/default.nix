{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, poetry-core
, textfsm
, pytestCheckHook
, ruamel_yaml
, yamllint
}:

buildPythonPackage rec {
  pname = "ntc-templates";
  version = "2.3.2";
  format = "pyproject";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "networktocode";
    repo = pname;
    rev = "v${version}";
    sha256 = "0sga86ajbh3a8wsb7q5mxzxhlg4fds8pr33ybjgi1sda4bvp2dvp";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    textfsm
  ];

  checkInputs = [
    pytestCheckHook
    ruamel_yaml
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
