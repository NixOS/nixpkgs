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
  version = "5.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "dvc-objects";
    tag = version;
    hash = "sha256-Lq881EnszwS+o8vaiiVgerdXAcalLT0PIJoW98+rw7w=";
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

  meta = with lib; {
    description = "Library for DVC objects";
    homepage = "https://github.com/iterative/dvc-objects";
    changelog = "https://github.com/iterative/dvc-objects/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
