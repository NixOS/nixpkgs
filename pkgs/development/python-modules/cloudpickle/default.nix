{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cloudpickle";
  version = "3.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cloudpipe";
    repo = "cloudpickle";
    tag = "v${version}";
    hash = "sha256-BsCOEpNCNqq8PS+SdbzF1wq0LXEmtcHJs0pdt2qFw/w=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "cloudpickle" ];

  disabledTestPaths = [
    # ModuleNotFoundError: No module named 'psutil'
    # (because _make_cwd_env() overwrites $PYTHONPATH)
    "tests/cloudpickle_test.py"
  ];

  meta = {
    changelog = "https://github.com/cloudpipe/cloudpickle/blob/${src.tag}/CHANGES.md";
    description = "Extended pickling support for Python objects";
    homepage = "https://github.com/cloudpipe/cloudpickle";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
