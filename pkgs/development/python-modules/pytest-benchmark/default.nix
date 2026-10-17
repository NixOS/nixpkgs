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
  py-cpuinfo2,
  pygal,
  pytest,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  setuptools,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-benchmark";
  version = "5.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ionelmc";
    repo = "pytest-benchmark";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f3v+jAPMz4Cc+Al3pwqb887QzhGI5k5W80C4Vnk4qt4=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  dependencies = [ py-cpuinfo2 ];

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
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

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
    changelog = "https://github.com/ionelmc/pytest-benchmark/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    description = "Pytest fixture for benchmarking code";
    homepage = "https://github.com/ionelmc/pytest-benchmark";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
