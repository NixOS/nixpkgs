{
  lib,
  stdenv,
  adal,
  buildPythonPackage,
  certifi,
  durationpy,
  fetchFromGitHub,
  google-auth,
  mock,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  pyyaml,
  requests,
  requests-oauthlib,
  setuptools,
  six,
  urllib3,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "kubernetes";
  version = "32.0.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "kubernetes-client";
    repo = "python";
    tag = "v${version}";
    hash = "sha256-pQuo2oLWMmq4dHTqJYL+Z1xg3ZoYp9ZzLDT7jWIsglo=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    certifi
    durationpy
    google-auth
    python-dateutil
    pyyaml
    requests
    requests-oauthlib
    six
    urllib3
    websocket-client
  ];

  optional-dependencies = {
    adal = [ adal ];
  };

  pythonImportsCheck = [ "kubernetes" ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # AssertionError: <class 'urllib3.poolmanager.ProxyManager'> != <class 'urllib3.poolmanager.Poolmanager'>
    "test_rest_proxycare"
  ];

  meta = with lib; {
    description = "Kubernetes Python client";
    homepage = "https://github.com/kubernetes-client/python";
    changelog = "https://github.com/kubernetes-client/python/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ lsix ];
  };
}
