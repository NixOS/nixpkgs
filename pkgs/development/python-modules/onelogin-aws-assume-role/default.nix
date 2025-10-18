{
  boto3,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  lxml,
  onelogin_2,
  pyyaml,
  setuptools,
}:

buildPythonPackage rec {
  pname = "onelogin-aws-assume-role";
  version = "1.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "onelogin";
    repo = "onelogin-python-aws-assume-role";
    rev = "v${version}";
    hash = "sha256-cHaelV6Mkgpv5XaJFRzqJLWfdZ9ctG7GPAMkGnvIpT0=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    boto3
    lxml
    onelogin_2
    pyyaml
  ];

  meta = with lib; {
    description = "Assume an AWS Role and get temporary credentials using OneLogin";
    homepage = "https://github.com/onelogin/onelogin-python-aws-assume-role";
    changelog = "https://github.com/onelogin/onelogin-python-aws-assume-role/tag/${src.rev}";
    maintainers = with maintainers; [ gjhenrique ];
    mainProgram = "onelogin-aws-assume-role";
  };
}
