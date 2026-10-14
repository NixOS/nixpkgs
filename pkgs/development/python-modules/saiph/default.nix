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
  version = "3.0.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "octopize";
    repo = "saiph";
    tag = "saiph-v${finalAttrs.version}";
    hash = "sha256-e41fa0C3ZT8mg+oHLU6VsQKgnCh59uO3bksO46A4t1M=";
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
