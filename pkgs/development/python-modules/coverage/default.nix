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
  version = "7.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nedbat";
    repo = "coveragepy";
    tag = version;
    hash = "sha256-PCMGxyG5zIc8iigi9BsuhyuyQindZnewqTgxErT/jHw=";
  };

  postPatch = ''
    # don't write to Nix store
    substituteInPlace tests/conftest.py \
      --replace-fail 'if WORKER == "none":' "if False:"
  '';

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
    "test_all_our_source_files"
    "test_doctest"
    "test_files_up_one_level"
    "test_get_encoded_zip_files"
    "test_metadata"
    "test_more_metadata"
    "test_multi"
    "test_no_duplicate_packages"
    "test_xdist_sys_path_nuttiness_is_fixed"
    "test_zipfile"
  ]
  ++ lib.optionals (isPy312 && stdenv.hostPlatform.system == "x86_64-darwin") [
    # substring that may not be in string is part of the pytest output hash, which appears in the string
    "test_nothing_specified"
    "test_omit"
    "test_omit_2"
    "test_omit_as_string"
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
