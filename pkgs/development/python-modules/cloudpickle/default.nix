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
  version = "3.1.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "cloudpipe";
    repo = "cloudpickle";
    tag = "v${version}";
    hash = "sha256-e8kEznjuIrdjNsXwXJO3lcEEpiCR+UQzXnGrTarUb5E=";
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
