{ lib, buildPythonPackage, fetchPypi, six, pyyaml, click, pytestrunner }:

buildPythonPackage rec {
  pname = "cfn-flip";
  version = "1.2.2";

  src = fetchPypi {
    pname = "cfn_flip";
    inherit version;
    sha256 = "05n5vvc5lqdzssgyb8kvb23byavs84ww4vbylaj13kakxxn05pcd";
  };

  propagatedBuildInputs = [ six pyyaml click ];
  nativeBuildInputs = [ pytestrunner ];

  # No tests in Pypi
  doCheck = false;

  meta = with lib; {
    description = "Tool for converting AWS CloudFormation templates between JSON and YAML formats";
    homepage = https://github.com/awslabs/aws-cfn-template-flip;
    license = licenses.asl20;
    maintainers = with maintainers; [ psyanticy ];
  };
}
