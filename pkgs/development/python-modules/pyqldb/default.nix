{ lib, buildPythonPackage, fetchFromGitHub, boto3, amazon-ion, ionhash, pytestCheckHook }:

buildPythonPackage rec {
  pname = "pyqldb";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "amazon-qldb-driver-python";
    rev = "v${version}";
    sha256 = "sha256-TKf43+k428h8T6ye6mJrnK9D4J1xpIu0QacM7lWJF7w=";
  };

  propagatedBuildInputs = [ boto3 amazon-ion ionhash ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export AWS_DEFAULT_REGION=us-east-1
  '';

  pytestFlagsArray = [ "tests/unit" ];

  pythonImportsCheck = [ "pyqldb" ];

  meta = with lib; {
    description = "Python driver for Amazon QLDB";
    homepage = "https://github.com/awslabs/amazon-qldb-driver-python";
    license = licenses.asl20;
    maintainers = [ maintainers.terlar ];
  };
}
