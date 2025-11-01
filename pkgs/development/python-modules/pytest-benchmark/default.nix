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
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "pytest-benchmark";
  version = "5.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ionelmc";
    repo = "pytest-benchmark";
    tag = "v${version}";
    hash = "sha256-BM17nrJfoOHkl7hOeY/VdoH5oEQP6EJWeNXa5x8/5UM=";
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
    writableTmpDirAsHomeHook
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  preCheck = ''
    export PATH="$out/bin:$PATH"
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
    changelog = "https://github.com/ionelmc/pytest-benchmark/blob/${src.tag}/CHANGELOG.rst";
    description = "Pytest fixture for benchmarking code";
    homepage = "https://github.com/ionelmc/pytest-benchmark";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
