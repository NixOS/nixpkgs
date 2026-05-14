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
  version = "5.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "dvc-objects";
    tag = version;
    hash = "sha256-COrHD7RtmShdC7YWFc+S3xi/Xxt+Afrj3vaCLfE8t28=";
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
    homepage = "https://github.com/iterative/dvc-objects";
    changelog = "https://github.com/iterative/dvc-objects/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
