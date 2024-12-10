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
  version = "31.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tomplus";
    repo = "kubernetes_asyncio";
    rev = "refs/tags/${version}";
    hash = "sha256-YKBqhUeLqLiQ6bK235zTm4salnSLUxl4DUiFLQSjWqw=";
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
