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
  version = "2.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "venth";
    repo = pname;
    rev = version;
    hash = "sha256-0BURXbEOZvb8kszuajLtR+V7HjJycCBAQrm3WqpVB1w=";
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

  patches = [
    # Switch to poetry-core, https://github.com/venth/aws-adfs/pull/230
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/venth/aws-adfs/commit/da095ccf64629d36a6045ffec2684038378ee690.patch";
      sha256 = "sha256-xg4c7iIonkUmNN74q/UeGSuYP3to7q4cLW6+TMW9nh4=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'boto3 = "^1.20.50"' 'boto3 = "*"' \
      --replace 'botocore = ">=1.12.6"' 'botocore = "*"'
  '';

  checkInputs = [
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
