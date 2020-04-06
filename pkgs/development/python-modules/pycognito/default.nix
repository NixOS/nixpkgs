{ lib
, buildPythonPackage
, fetchFromGitHub
, cryptography
, boto3
, envs
, python-jose
, requests
, mock
, isPy27
}:

buildPythonPackage rec {
  pname = "pycognito";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "pvizeli";
    repo = "pycognito";
    rev = version;
    sha256 = "01zns522awm5yp5cbk1y7k7px534i5akiivip709i1naph3hvnfk";
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

  checkInputs = [ mock ];

  meta = with lib; {
    description = "Python class to integrate Boto3's Cognito client so it is easy to login users. With SRP support";
    homepage = "https://GitHub.com/pvizeli/pycognito";
    license = licenses.asl20;
    maintainers = [ maintainers.mic92 ];
  };
}
