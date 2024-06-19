{
  lib,
  stdenv,
  adal,
  buildPythonPackage,
  certifi,
  fetchFromGitHub,
  google-auth,
  mock,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  pythonRelaxDepsHook,
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
  version = "29.0.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "kubernetes-client";
    repo = "python";
    rev = "refs/tags/v${version}";
    hash = "sha256-KChfiXYnJTeIW6O7GaK/fMxU2quIvbjc4gB4aZBeTtI=";
  };

  postPatch = ''
    substituteInPlace kubernetes/base/config/kube_config_test.py \
      --replace-fail "assertEquals" "assertEqual"
  '';

  pythonRelaxDeps = [ "urllib3" ];

  build-system = [
    pythonRelaxDepsHook
    setuptools
  ];

  dependencies = [
    certifi
    google-auth
    python-dateutil
    pyyaml
    requests
    requests-oauthlib
    six
    urllib3
    websocket-client
  ];

  passthru.optional-dependencies = {
    adal = [ adal ];
  };

  pythonImportsCheck = [ "kubernetes" ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  disabledTests = lib.optionals stdenv.isDarwin [
    # AssertionError: <class 'urllib3.poolmanager.ProxyManager'> != <class 'urllib3.poolmanager.Poolmanager'>
    "test_rest_proxycare"
  ];

  meta = with lib; {
    description = "Kubernetes Python client";
    homepage = "https://github.com/kubernetes-client/python";
    changelog = "https://github.com/kubernetes-client/python/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ lsix ];
  };
}
