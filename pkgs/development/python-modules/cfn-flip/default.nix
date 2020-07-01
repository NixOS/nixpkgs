{ buildPythonPackage
, fetchFromGitHub
, lib

# pythonPackages
, click
, pytest
, pytestcov
, pytestrunner
, pyyaml
, six
}:

buildPythonPackage rec {
  pname = "cfn-flip";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-cfn-template-flip";
    rev = version;
    sha256 = "05fk725a1i3zl3idik2hxl3w6k1ln0j33j3jdq1gvy1sfyc79ifm";
  };

  propagatedBuildInputs = [
    click
    pyyaml
    six
  ];

  checkInputs = [
    pytest
    pytestcov
    pytestrunner
  ];

  checkPhase = ''
    py.test \
      --cov=cfn_clean \
      --cov=cfn_flip \
      --cov=cfn_tools \
      --cov-report term-missing \
      --cov-report html
  '';

  meta = with lib; {
    description = "Tool for converting AWS CloudFormation templates between JSON and YAML formats";
    homepage = "https://github.com/awslabs/aws-cfn-template-flip";
    license = licenses.asl20;
    maintainers = with maintainers; [
      kamadorueda
      psyanticy
    ];
  };
}
