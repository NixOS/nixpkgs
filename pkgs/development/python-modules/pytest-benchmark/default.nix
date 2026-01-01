{
  lib,
  aspectlib,
  buildPythonPackage,
  elasticsearch,
  fetchFromGitHub,
  freezegun,
  gitMinimal,
  mercurial,
  nbmake,
  py-cpuinfo,
  pygal,
  pytest,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  setuptools,
<<<<<<< HEAD
  writableTmpDirAsHomeHook,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "pytest-benchmark";
<<<<<<< HEAD
  version = "5.2.3";
=======
  version = "5.1.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ionelmc";
    repo = "pytest-benchmark";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-qjgP9H3WUYFm1xamOqhGk5YJQv94QfyJvrRoltHJHHc=";
=======
    hash = "sha256-4fD9UfZ6jtY7Gx/PVzd1JNWeQNz+DJ2kQmCku2TgxzI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  dependencies = [ py-cpuinfo ];

  optional-dependencies = {
    aspect = [ aspectlib ];
    histogram = [
      pygal
      # FIXME package pygaljs
      setuptools
    ];
    elasticsearch = [ elasticsearch ];
  };

  pythonImportsCheck = [ "pytest_benchmark" ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    freezegun
    gitMinimal
    mercurial
    nbmake
    pytestCheckHook
<<<<<<< HEAD
    writableTmpDirAsHomeHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  preCheck = ''
    export PATH="$out/bin:$PATH"
  '';

  disabledTests = lib.optionals (pythonOlder "3.12") [
    # AttributeError: 'PluginImportFixer' object has no attribute 'find_spec'
    "test_compare_1"
    "test_compare_2"
    "test_regression_checks"
    "test_regression_checks_inf"
    "test_rendering"
  ];

  meta = {
    changelog = "https://github.com/ionelmc/pytest-benchmark/blob/${src.tag}/CHANGELOG.rst";
=======
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  preCheck = ''
    export PATH="$out/bin:$PATH"
    export HOME=$(mktemp -d)
  '';

  disabledTests =
    lib.optionals (pythonOlder "3.12") [
      # AttributeError: 'PluginImportFixer' object has no attribute 'find_spec'
      "test_compare_1"
      "test_compare_2"
      "test_regression_checks"
      "test_regression_checks_inf"
      "test_rendering"
    ]
    ++ lib.optionals (pythonAtLeast "3.13") [
      # argparse usage changes mismatches test artifact
      "test_help"
    ];

  meta = {
    changelog = "https://github.com/ionelmc/pytest-benchmark/blob/${src.rev}/CHANGELOG.rst";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Pytest fixture for benchmarking code";
    homepage = "https://github.com/ionelmc/pytest-benchmark";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
