{ lib
, addict
, buildPythonPackage
, coverage
, fetchFromGitHub
, lmdb
, matplotlib
, mlflow
, numpy
, opencv4
, parameterized
, pytestCheckHook
, pythonOlder
, pyyaml
, rich
, termcolor
, torch
, yapf
}:

buildPythonPackage rec {
  pname = "mmengine";
  version = "0.8.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "open-mmlab";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-kJhcw6Hpzx3s5WHeLTF8pydbAKXwfVgvxo7SsSN5gls=";
  };

  propagatedBuildInputs = [
    addict
    matplotlib
    numpy
    opencv4
    pyyaml
    rich
    termcolor
    yapf
  ];

  nativeCheckInputs = [
    coverage
    lmdb
    mlflow
    torch
    parameterized
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  pythonImportsCheck = [
    "mmengine"
  ];

  disabledTestPaths = [
    # AttributeError
    "tests/test_fileio/test_backends/test_petrel_backend.py"
  ];

  disabledTests = [
    # Tests are disabled due to sandbox
    "test_fileclient"
    "test_http_backend"
    "test_misc"
    # RuntimeError
    "test_dump"
    "test_deepcopy"
    "test_copy"
    "test_lazy_import"
    # AssertionError
    "test_lazy_module"
  ];

  meta = with lib; {
    description = "Library for training deep learning models based on PyTorch";
    homepage = "https://github.com/open-mmlab/mmengine";
    changelog = "https://github.com/open-mmlab/mmengine/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ rxiao ];
  };
}
