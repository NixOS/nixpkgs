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
<<<<<<< HEAD
  version = "7.13.1";
=======
  version = "7.12.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "coveragepy";
    repo = "coveragepy";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-xdbgHUE+vbSiqLRDhd5G5u90VU5+TxLehAuwdhdGzBQ=";
=======
    hash = "sha256-Geoj48/MIrI8YDdyvAz7AaSa9wY41KhW5Ret4pzpLjc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    # tests expect coverage source to be there
    "test_all_our_source_files"
    "test_real_code_regions"
  ];

=======
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

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    changelog = "https://github.com/coveragepy/coveragepy/blob/${src.tag}/CHANGES.rst";
    description = "Code coverage measurement for Python";
    homepage = "https://github.com/coveragepy/coveragepy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
