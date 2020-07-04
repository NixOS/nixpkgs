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
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "pvizeli";
    repo = "pycognito";
    rev = version;
    sha256 = "0wy6d274xda7v6dazv10h2vwig2avfyz8mh2lpd1a5k7i06r335r";
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
