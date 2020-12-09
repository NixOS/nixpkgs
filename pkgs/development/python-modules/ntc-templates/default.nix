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
  version = "1.6.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "networktocode";
    repo = pname;
    rev = "dc27599b0c5f3bb6ff23049e781b5dab2849c2c3";  # not tagged
    sha256 = "1vg5y5c51vc9dj3b8qcffh6dz85ri11zb1azxmyvgbq86pcvbx9f";
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
