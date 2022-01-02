{ lib
, boto3
, buildPythonPackage
, envs
, fetchFromGitHub
, mock
, pytestCheckHook
, python-jose
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "pycognito";
  version = "2021.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pvizeli";
    repo = pname;
    rev = version;
    sha256 = "sha256-LHLFbr25DivdkdD2patGSljAf7VbeTh+DfmQqkbbKa0=";
  };

  propagatedBuildInputs = [
    boto3
    envs
    python-jose
    requests
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'python-jose[cryptography]' 'python-jose'
  '';

  pytestFlagsArray = [
    "tests.py"
  ];

  pythonImportsCheck = [
    "pycognito"
  ];

  meta = with lib; {
    description = "Python class to integrate Boto3's Cognito client so it is easy to login users. With SRP support";
    homepage = "https://github.com/pvizeli/pycognito";
    license = licenses.asl20;
    maintainers = with maintainers; [ mic92 ];
  };
}
