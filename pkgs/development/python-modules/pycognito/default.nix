{ lib
, boto3
, buildPythonPackage
, envs
, fetchFromGitHub
, isPy27
, freezegun
, mock
, moto
, pyjwt
, pytestCheckHook
, requests
, requests-mock
}:

buildPythonPackage rec {
  pname = "pycognito";
  version = "2024.2.0";
  format = "setuptools";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "pvizeli";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-VYko5KcJvnhPUceTll2BBJWb88SYnSL7S3mZ7XSLPSQ=";
  };

  propagatedBuildInputs = [
    boto3
    envs
    pyjwt
    requests
  ]
  ++ pyjwt.optional-dependencies.crypto;

  nativeCheckInputs = [
    freezegun
    mock
    moto
    pytestCheckHook
    requests-mock
  ]
  ++ moto.optional-dependencies.cognitoidp;

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
