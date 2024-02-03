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
  version = "2023.5.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "pvizeli";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-2Aqid2bd5BAnWQ+Wtji0zXjLAmSpyJNGqJ0VroGi6lY=";
  };

  propagatedBuildInputs = [
    boto3
    envs
    python-jose
    requests
  ];

  nativeCheckInputs = [
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

  disabledTests = [
    # requires network access
    "test_srp_requests_http_auth"
  ];

  pythonImportsCheck = [ "pycognito" ];

  meta = with lib; {
    description = "Python class to integrate Boto3's Cognito client so it is easy to login users. With SRP support";
    homepage = "https://github.com/pvizeli/pycognito";
    license = licenses.asl20;
    maintainers = with maintainers; [ mic92 ];
  };
}
