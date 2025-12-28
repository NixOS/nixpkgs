{
  lib,
  stdenv,
  buildPythonPackage,
  isPy312,
  fetchFromGitHub,
  fetchpatch,
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
  version = "7.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "coveragepy";
    repo = "coveragepy";
    tag = version;
    hash = "sha256-2i01Jlk4oj/0WhoYE1BgeKKjZK3YpEOrGHEgNhTruR4=";
  };

  patches = [
    # test: correctly default the core being tested
    # This fixes test_coverage_stop_in_threads
    # https://github.com/coveragepy/coveragepy/issues/2109
    (fetchpatch {
      url = "https://github.com/coveragepy/coveragepy/commit/2f2e540709371f6184c2731f6d076bc782d37a3d.patch";
      hash = "sha256-lwQ8OM9OWZAwrjExuPeGKSLEF+pYhgDHyAlgXzHiQ0M=";
      excludes = [ "CHANGES.rst" ];
    })
  ];

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
    changelog = "https://github.com/coveragepy/coveragepy/blob/${src.tag}/CHANGES.rst";
    description = "Code coverage measurement for Python";
    homepage = "https://github.com/coveragepy/coveragepy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
