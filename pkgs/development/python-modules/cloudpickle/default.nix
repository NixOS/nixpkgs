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
  version = "3.0.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "cloudpipe";
    repo = "cloudpickle";
    rev = "refs/tags/v${version}";
    hash = "sha256-UeKVwzT0m4fhEVnG7TvQsFR99JsmwwoXmr+rWnTCeJU=";
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
    changelog = "https://github.com/cloudpipe/cloudpickle/blob/v${version}/CHANGES.md";
    description = "Extended pickling support for Python objects";
    homepage = "https://github.com/cloudpipe/cloudpickle";
    license = with licenses; [ bsd3 ];
    maintainers = [ ];
  };
}
