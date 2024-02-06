{ lib
, buildPythonPackage
, fetchFromGitHub
, fsspec
, funcy
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
, reflink
, setuptools-scm
, shortuuid
}:

buildPythonPackage rec {
  pname = "dvc-objects";
  version = "4.0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "dvc-objects";
    rev = "refs/tags/${version}";
    hash = "sha256-cNiEjsrMPogQnz2E5KrublcLQV0A28EBaYjSOeL3z9A=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --benchmark-skip" ""
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    fsspec
  ]  ++ lib.optionals (pythonOlder "3.12") [
    funcy
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    reflink
    shortuuid
  ];

  pythonImportsCheck = [
    "dvc_objects"
  ];

  disabledTestPaths = [
    # Disable benchmarking
    "tests/benchmarks/"
  ];

  meta = with lib; {
    description = "Library for DVC objects";
    homepage = "https://github.com/iterative/dvc-objects";
    changelog = "https://github.com/iterative/dvc-objects/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
