{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  coreutils,

  # build-system
  setuptools,

  # dependencies
  aiohttp,
  certifi,
  python-dateutil,
  pyyaml,
  six,
  urllib3,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "kubernetes-asyncio";
  version = "33.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tomplus";
    repo = "kubernetes_asyncio";
    tag = version;
    hash = "sha256-Ei5Y2IBBk8AoMQQBHOvKkJ1H+9dmnz22qrrZKrWazVE=";
  };

  postPatch = ''
    substituteInPlace kubernetes_asyncio/config/google_auth_test.py \
      --replace-fail "/bin/echo" "${lib.getExe' coreutils "echo"}"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
    certifi
    python-dateutil
    pyyaml
    six
    urllib3
  ];

  pythonImportsCheck = [
    "kubernetes_asyncio"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Python asynchronous client library for Kubernetes http://kubernetes.io";
    homepage = "https://github.com/tomplus/kubernetes_asyncio";
    changelog = "https://github.com/tomplus/kubernetes_asyncio/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
