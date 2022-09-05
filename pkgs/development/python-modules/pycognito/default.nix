{ lib
, boto3
, buildPythonPackage
, envs
, fetchFromGitHub
, isPy27
, freezegun
, mock
, moto
, pytestCheckHook
, python-jose
, requests
, requests-mock
}:

buildPythonPackage rec {
  pname = "pycognito";
  version = "2022.08.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "pvizeli";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-A80iYF2zwM2YkhnwJMU/bZezsCzs389ro1fikG8vXSA=";
  };

  propagatedBuildInputs = [
    boto3
    envs
    python-jose
    requests
  ];

  checkInputs = [
    freezegun
    mock
    moto
    pytestCheckHook
    requests-mock
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'python-jose[cryptography]' 'python-jose'
  '';

  pytestFlagsArray = [ "tests.py" ];

  pythonImportsCheck = [ "pycognito" ];

  meta = with lib; {
    description = "Python class to integrate Boto3's Cognito client so it is easy to login users. With SRP support";
    homepage = "https://github.com/pvizeli/pycognito";
    license = licenses.asl20;
    maintainers = with maintainers; [ mic92 ];
  };
}
