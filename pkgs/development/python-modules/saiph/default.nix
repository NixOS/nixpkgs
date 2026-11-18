{
  lib,
  buildPythonPackage,
  hatchling,
  fetchFromGitHub,
  pytestCheckHook,
  doubles,
  msgspec,
  matplotlib,
  numpy,
  pandas,
  pydantic,
  scikit-learn,
  scipy,
  toolz,
}:

buildPythonPackage (finalAttrs: {
  pname = "saiph";
  version = "3.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "octopize";
    repo = "saiph";
    tag = "saiph-v${finalAttrs.version}";
    hash = "sha256-x1S9QLPm0/+oWeYxt4RO9gZzh0qMfzRczTotCd6+07s=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    msgspec
    matplotlib
    numpy
    pandas
    pydantic
    scikit-learn
    scipy
    toolz
  ];

  nativeCheckInputs = [
    pytestCheckHook
    doubles
  ];

  disabledTests = [
    # No need for benchmarks
    "benchmark_test.py"

    # pluggy.PluggyTeardownRaisedWarning: A plugin raised an exception during an old-style hookwrapper teardown.
    "test_encode_decode_model"
    "test_fit_mix"
    "test_var_cor"
    "test_var_ratio"
    "test_get_variable_contributions"
  ];

  pythonImportsCheck = [
    "saiph"
  ];

  meta = {
    description = "Package enabling to project data";
    homepage = "https://github.com/octopize/saiph";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ b-rodrigues ];
  };
})
