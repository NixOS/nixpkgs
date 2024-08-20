{
  lib,
  aws-sam-cli,
  boto3,
  buildPythonPackage,
  cfn-lint,
  fetchFromGitHub,
  mock,
  moto,
  mypy-boto3-ebs,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  typer,
  urllib3,
}:

buildPythonPackage rec {
  pname = "dsnap";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "RhinoSecurityLabs";
    repo = "dsnap";
    rev = "refs/tags/v${version}";
    hash = "sha256-yKch+tKjFhvZfzloazMH378dkERF8gnZEX1Som+d670=";
  };

  postPatch = ''
    # Is no direct dependency
    substituteInPlace pyproject.toml \
      --replace-fail 'urllib3 = "^1.26.4"' 'urllib3 = "*"'
  '';

  build-system = [ poetry-core ];

  dependencies = [
    boto3
    urllib3
  ];

  passthru.optional-dependencies = {
    cli = [ typer ];
    scannerd = [
      aws-sam-cli
      cfn-lint
    ];
  };

  nativeCheckInputs = [
    mock
    moto
    mypy-boto3-ebs
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  # https://github.com/RhinoSecurityLabs/dsnap/issues/26
  # ImportError: cannot import name 'mock_iam' from 'moto'
  doCheck = false;

  pythonImportsCheck = [ "dsnap" ];

  meta = with lib; {
    description = "Utility for downloading and mounting EBS snapshots using the EBS Direct API's";
    homepage = "https://github.com/RhinoSecurityLabs/dsnap";
    changelog = "https://github.com/RhinoSecurityLabs/dsnap/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
    mainProgram = "dsnap";
  };
}
