{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  flit-core,

  # tests
  psutil,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cloudpickle";
  version = "3.1.2";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "cloudpipe";
    repo = "cloudpickle";
    tag = "v${version}";
    hash = "sha256-BsCOEpNCNqq8PS+SdbzF1wq0LXEmtcHJs0pdt2qFw/w=";
  };

  nativeBuildInputs = [ flit-core ];

  nativeCheckInputs = [
    psutil
    pytestCheckHook
  ];

  pythonImportsCheck = [ "cloudpickle" ];

  disabledTestPaths = [
    # ModuleNotFoundError: No module named 'psutil'
    "tests/cloudpickle_test.py"
  ];

  meta = with lib; {
    changelog = "https://github.com/cloudpipe/cloudpickle/blob/${src.tag}/CHANGES.md";
    description = "Extended pickling support for Python objects";
    homepage = "https://github.com/cloudpipe/cloudpickle";
    license = with licenses; [ bsd3 ];
    maintainers = [ ];
  };
}
