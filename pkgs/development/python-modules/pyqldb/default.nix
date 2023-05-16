{ lib, buildPythonPackage, fetchFromGitHub, boto3, amazon-ion, ionhash, pytestCheckHook }:

buildPythonPackage rec {
  pname = "pyqldb";
<<<<<<< HEAD
  version = "3.2.3";
=======
  version = "3.2.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "amazon-qldb-driver-python";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-TyIXvk3ZJn5J2SBFDTPJpSnGFOFheXIqR2daL5npOk8=";
=======
    rev = "v${version}";
    hash = "sha256-TKf43+k428h8T6ye6mJrnK9D4J1xpIu0QacM7lWJF7w=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
