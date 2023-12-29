{ lib
, buildPythonPackage
, fetchFromGitHub
, fsspec
, funcy
, pytest-mock
, pytestCheckHook
, pythonOlder
, reflink
, setuptools-scm
, shortuuid
}:

buildPythonPackage rec {
  pname = "dvc-objects";
  version = "3.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "dvc-objects";
    rev = "refs/tags/${version}";
    hash = "sha256-hpiDbECVXbBkewJa+RwrgTQFEFAb3Ir2qs0ENYuJtwI=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --benchmark-skip" ""
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    fsspec
    funcy
    shortuuid
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
    reflink
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
