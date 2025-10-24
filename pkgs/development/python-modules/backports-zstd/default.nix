{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
  zstd,
}:

buildPythonPackage rec {
  pname = "backports-zstd";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rogdham";
    repo = "backports.zstd";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-PNM/iaj4r2M1IYh6RDRVMm4gn/UMHqlxnI5Lh4DTRmQ=";
  };

  postPatch = ''
    # need to preserve $PYTHONPATH when calling sys.executable
    substituteInPlace tests/test/support/script_helper.py \
      --replace-fail "return __cached_interp_requires_environment" "return True"
  '';

  build-system = [ setuptools ];

  pypaBuildFlags = [ "--config-setting=--build-option=--system-zstd" ];

  buildInputs = [ zstd ];

  pythonImportsCheck = [ "backports.zstd" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests" ];

  disabledTestPaths = [
    # sandbox doesn't allow setting SUID bit
    "tests/test/test_tarfile.py::TestExtractionFilters::test_modes"
  ];

  meta = {
    changelog = "https://github.com/rogdham/backports.zstd/blob/${src.tag}/CHANGELOG.md";
    description = "Backport of compression.zstd";
    homepage = "https://github.com/rogdham/backports.zstd";
    license = lib.licenses.psfl;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
