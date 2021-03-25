{ lib
, boto3
, buildPythonPackage
, cryptography
, envs
, fetchFromGitHub
, isPy27
, mock
, pytestCheckHook
, python-jose
, requests
}:

buildPythonPackage rec {
  pname = "pycognito";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "pvizeli";
    repo = pname;
    rev = version;
    sha256 = "sha256-RJeHPCTuaLN+zB0N0FGt4qrTI6++1ks5iBn64Cx0Psc=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'python-jose[cryptography]' 'python-jose'
  '';

  propagatedBuildInputs = [
    boto3
    envs
    python-jose
    requests
  ];

  disabled = isPy27;

  checkInputs = [
    mock
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests.py" ];
  pythonImportsCheck = [ "pycognito" ];

  meta = with lib; {
    description = "Python class to integrate Boto3's Cognito client so it is easy to login users. With SRP support";
    homepage = "https://GitHub.com/pvizeli/pycognito";
    license = licenses.asl20;
    maintainers = [ maintainers.mic92 ];
  };
}
