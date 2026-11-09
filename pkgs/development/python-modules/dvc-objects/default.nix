{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fsspec,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  reflink,
  setuptools-scm,
  shortuuid,
}:

buildPythonPackage rec {
  pname = "dvc-objects";
  version = "5.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "treeverse";
    repo = "dvc-objects";
    tag = version;
    hash = "sha256-ySmEnc3HivLgY6OAj24a7fMfAPAZ+lt8/VOS8biDhvM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --benchmark-skip" ""
  '';

  build-system = [ setuptools-scm ];

  dependencies = [ fsspec ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    reflink
    shortuuid
  ];

  pythonImportsCheck = [ "dvc_objects" ];

  disabledTestPaths = [
    # Disable benchmarking
    "tests/benchmarks/"
  ];

  meta = {
    description = "Library for DVC objects";
    homepage = "https://github.com/treeverse/dvc-objects";
    changelog = "https://github.com/treeverse/dvc-objects/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
