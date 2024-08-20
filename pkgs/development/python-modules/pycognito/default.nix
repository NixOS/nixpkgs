{
  lib,
  boto3,
  buildPythonPackage,
  envs,
  fetchFromGitHub,
  freezegun,
  mock,
  moto,
  pyjwt,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-mock,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pycognito";
  version = "2024.5.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pvizeli";
    repo = "pycognito";
    rev = "refs/tags/${version}";
    hash = "sha256-U23fFLru4j6GnWMcYtsCW9BVJkVcCoefPH6oMijYGew=";
  };

  build-system = [ setuptools ];

  dependencies = [
    boto3
    envs
    pyjwt
    requests
  ] ++ pyjwt.optional-dependencies.crypto;

  nativeCheckInputs = [
    freezegun
    mock
    moto
    pytestCheckHook
    requests-mock
  ] ++ moto.optional-dependencies.cognitoidp;

  pytestFlagsArray = [ "tests.py" ];

  disabledTests = [
    # Test requires network access
    "test_srp_requests_http_auth"
  ];

  pythonImportsCheck = [ "pycognito" ];

  meta = with lib; {
    description = "Python class to integrate Boto3's Cognito client so it is easy to login users. With SRP support";
    homepage = "https://github.com/pvizeli/pycognito";
    changelog = "https://github.com/NabuCasa/pycognito/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ mic92 ];
  };
}
