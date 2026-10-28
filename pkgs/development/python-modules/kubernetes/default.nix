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
  version = "35.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kubernetes-client";
    repo = "python";
    tag = "v${version}";
    hash = "sha256-q52LqOz8aQkzWPwEy1c2jUQJ3hQ2sDVrYGkOgOc7Mm0=";
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
  ++ lib.concatAttrValues optional-dependencies;

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # AssertionError: <class 'urllib3.poolmanager.ProxyManager'> != <class 'urllib3.poolmanager.Poolmanager'>
    "test_rest_proxycare"
  ];

  meta = {
    description = "Kubernetes Python client";
    homepage = "https://github.com/kubernetes-client/python";
    changelog = "https://github.com/kubernetes-client/python/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
  };
}
