{ lib
, boto3
, botocore
, buildPythonPackage
, click
, configparser
, fetchFromGitHub
, fetchpatch
, fido2
, lxml
, poetry-core
, pyopenssl
, pytestCheckHook
, pythonOlder
, requests
, requests-kerberos
, toml
}:

buildPythonPackage rec {
  pname = "aws-adfs";
  version = "2.8.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "venth";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-hMM7Z0s9t5vetgskiy7nb1W/kKCKHe0Q3kT2ngUVADA=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    boto3
    botocore
    click
    configparser
    fido2
    lxml
    pyopenssl
    requests
    requests-kerberos
  ];

  nativeCheckInputs = [
    pytestCheckHook
    toml
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pythonImportsCheck = [
    "aws_adfs"
  ];

  meta = with lib; {
    description = "Command line tool to ease AWS CLI authentication against ADFS";
    homepage = "https://github.com/venth/aws-adfs";
    license = licenses.psfl;
    maintainers = with maintainers; [ bhipple ];
  };
}
