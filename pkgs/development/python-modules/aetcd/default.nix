{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  grpcio,
  protobuf,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "aetcd";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "martyanov";
    repo = "aetcd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wGs1YG/7gCVMd6iS2RLoMBVJ93aO3dAG1x6/rrhK+C0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==82.0.1" "setuptools" \
      --replace-fail "setuptools-scm[toml]==10.0.5" "setuptools_scm"
  '';

  pythonRelaxDeps = [ "protobuf" ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    grpcio
    protobuf
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aetcd" ];

  disabledTestPaths = [
    # Tests require a running ectd instance
    "tests/integration/"
  ];

  meta = {
    description = "Python asyncio-based client for etcd";
    homepage = "https://github.com/martyanov/aetcd";
    changelog = "https://github.com/martyanov/aetcd/blob/${finalAttrs.src.tag}/docs/changelog.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
