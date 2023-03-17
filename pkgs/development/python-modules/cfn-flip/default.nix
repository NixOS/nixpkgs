{ lib
, buildPythonPackage
, click
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, pyyaml
, six
}:

buildPythonPackage rec {
  pname = "cfn-flip";
  version = "1.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-cfn-template-flip";
    rev = version;
    hash = "sha256-lfhTR3+D1FvblhQGF83AB8+I8WDPBTmo+q22ksgDgt4=";
  };

  propagatedBuildInputs = [
    click
    pyyaml
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    sed -i "/--cov/d" tox.ini
  '';

  disabledTests = [
    # TypeError: load() missing 1 required positional argument: 'Loader'
    "test_flip_to_yaml_with_longhand_functions"
    "test_yaml_no_ordered_dict"
  ];

  pythonImportsCheck = [
    "cfn_flip"
  ];

  meta = with lib; {
    description = "Tool for converting AWS CloudFormation templates between JSON and YAML formats";
    homepage = "https://github.com/awslabs/aws-cfn-template-flip";
    license = licenses.asl20;
    maintainers = with maintainers; [ kamadorueda psyanticy ];
  };
}
