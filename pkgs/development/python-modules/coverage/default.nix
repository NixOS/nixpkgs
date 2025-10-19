{
  lib,
  stdenv,
  buildPythonPackage,
  isPy312,
  fetchFromGitHub,
  flaky,
  hypothesis,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  tomli,
}:

buildPythonPackage rec {
  pname = "coverage";
  version = "7.10.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nedbat";
    repo = "coveragepy";
    tag = version;
    hash = "sha256-16t29ftyYBkGvzlV6+imjO+HM1UD/Nrhn+n4pK3h5iU=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    toml = lib.optionals (pythonOlder "3.11") [
      tomli
    ];
  };

  nativeCheckInputs = [
    flaky
    hypothesis
    pytest-xdist
    pytestCheckHook
  ];

  preCheck = ''
    export PATH="$PATH:$out/bin"
    # import from $out
    rm -r coverage
  '';

  disabledTests = [
    "test_doctest"
    "test_files_up_one_level"
    "test_get_encoded_zip_files"
    "test_multi"
    "test_no_duplicate_packages"
    "test_zipfile"
    # tests expect coverage source to be there
    "test_all_our_source_files"
    "test_metadata"
    "test_more_metadata"
    "test_real_code_regions"
  ];

  disabledTestPaths = [
    "tests/test_debug.py"
    "tests/test_plugins.py"
    "tests/test_process.py"
    "tests/test_report.py"
    "tests/test_venv.py"
  ];

  meta = {
    changelog = "https://github.com/nedbat/coveragepy/blob/${src.tag}/CHANGES.rst";
    description = "Code coverage measurement for Python";
    homepage = "https://github.com/nedbat/coveragepy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
