{
  lib,
  aspectlib,
  buildPythonPackage,
  elasticsearch,
  elastic-transport,
  fetchFromGitHub,
  freezegun,
  git,
  mercurial,
  nbmake,
  py-cpuinfo,
  pygal,
  pytest,
  pytestCheckHook,
  pytest-xdist,
  pythonAtLeast,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytest-benchmark";
  version = "5.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ionelmc";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4fD9UfZ6jtY7Gx/PVzd1JNWeQNz+DJ2kQmCku2TgxzI=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  dependencies = [ py-cpuinfo ];

  optional-dependencies = {
    aspect = [ aspectlib ];
    histogram = [
      pygal
      setuptools
    ];
    elasticsearch = [ elasticsearch ];
  };

  pythonImportsCheck = [ "pytest_benchmark" ];

  nativeCheckInputs = [
    elastic-transport
    freezegun
    git
    mercurial
    nbmake
    pytestCheckHook
    pytest-xdist
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

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

  meta = with lib; {
    changelog = "https://github.com/ionelmc/pytest-benchmark/blob/${src.rev}/CHANGELOG.rst";
    description = "Pytest fixture for benchmarking code";
    homepage = "https://github.com/ionelmc/pytest-benchmark";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dotlambda ];
  };
}
