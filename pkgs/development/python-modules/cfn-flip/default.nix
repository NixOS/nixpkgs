{ lib, buildPythonPackage, fetchPypi, six, pyyaml, click, pytestrunner }:

buildPythonPackage rec {
  pname = "cfn-flip";
  version = "1.1.0.post1";

  src = fetchPypi {
    pname = "cfn_flip";
    inherit version;
    sha256 = "16r01ijjwnq06ax5xrv6mq9l00f6sgzw776kr43zjai09xsbwwck";
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
