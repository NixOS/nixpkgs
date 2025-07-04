{
  lib,
  buildPythonPackage,
  decorator,
  fetchFromGitHub,
  numpy,
  pytestCheckHook,
  pythonOlder,
  scipy,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "paramz";
  version = "0.9.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sods";
    repo = "paramz";
    tag = "v${version}";
    hash = "sha256-SWmx70G5mm3eUmH2UIEmg5C7u9VDHiFw5aYCIr8UjPs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    decorator
    numpy
    scipy
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    substituteInPlace paramz/tests/parameterized_tests.py \
      --replace-fail "assertRaisesRegexp" "assertRaisesRegex"
  '';

  enabledTestPaths = [
    "paramz/tests/array_core_tests.py"
    "paramz/tests/cacher_tests.py"
    "paramz/tests/examples_tests.py"
    "paramz/tests/index_operations_tests.py"
    "paramz/tests/init_tests.py"
    "paramz/tests/lists_and_dicts_tests.py"
    "paramz/tests/model_tests.py"
    "paramz/tests/observable_tests.py"
    "paramz/tests/parameterized_tests.py"
    "paramz/tests/pickle_tests.py"
    "paramz/tests/verbose_optimize_tests.py"
  ];

  disabledTests = [
    # TypeError: arrays to stack must be passed as a "sequence" type such as list...
    "test_raveled_index"
    "test_regular_expression_misc"
  ];

  pythonImportsCheck = [ "paramz" ];

  meta = with lib; {
    description = "Parameterization framework for parameterized model creation and handling";
    homepage = "https://github.com/sods/paramz";
    changelog = "https://github.com/sods/paramz/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
