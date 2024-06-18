{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  boto3,
  amazon-ion,
  ionhash,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyqldb";
  version = "3.2.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "amazon-qldb-driver-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-TyIXvk3ZJn5J2SBFDTPJpSnGFOFheXIqR2daL5npOk8=";
  };

  propagatedBuildInputs = [
    boto3
    amazon-ion
    ionhash
  ];

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
