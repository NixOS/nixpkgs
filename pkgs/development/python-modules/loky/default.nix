{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  procps,

  # build-system
  setuptools,

  # dependencies
  cloudpickle,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "loky";
  version = "3.5.6";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "joblib";
    repo = "loky";
    tag = finalAttrs.version;
    hash = "sha256-XyYJTz9sElfIkLzLGuprvhzyjeaJkEBthFV4BsEv6gs=";
  };

  postPatch = ''
    substituteInPlace loky/backend/utils.py \
      --replace-fail \
        '"pgrep"' \
        '"${lib.getExe' procps "pgrep"}"'
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    cloudpickle
  ];

  pythonImportsCheck = [ "loky" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # FileNotFoundError: [Errno 2] No such file or directory: ''
    "test_resource_tracker"
  ];

  meta = {
    description = "Robust and reusable Executor for joblib";
    homepage = "https://github.com/joblib/loky";
    changelog = "https://github.com/joblib/loky/blob/${finalAttrs.src.tag}/CHANGES.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
