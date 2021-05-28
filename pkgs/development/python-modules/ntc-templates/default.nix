{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, textfsm
, pytestCheckHook
, ruamel_yaml
, yamllint
}:

buildPythonPackage rec {
  pname = "ntc-templates";
  version = "1.5.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "networktocode";
    repo = pname;
    rev = "v${version}";
    sha256 = "0pvd9n7hcmxl9cr8m1xlqcjmy3k2hga0qmn2k3x9hripjis7pbbi";
  };

  propagatedBuildInputs = [ textfsm ];

  checkInputs = [ pytestCheckHook ruamel_yaml yamllint ];

  # https://github.com/networktocode/ntc-templates/issues/743
  disabledTests = [ "test_raw_data_against_mock" "test_verify_parsed_and_reference_data_exists" ];

  meta = with lib; {
    description = "TextFSM templates for parsing show commands of network devices";
    homepage = "https://github.com/networktocode/ntc-templates";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
