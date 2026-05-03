{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pytestCheckHook,
  pytest-asyncio,
  pytest-benchmark,
  pytest-mock,
  pytest-timeout,
  pytest-django,
  pydot,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-statemachine";
  version = "3.0.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "python_statemachine";
    inherit (finalAttrs) version;
    hash = "sha256-kVI/nq1zwdb+zJddXG4L/jY/v1N8XwvzCbzQ+U+UQbI=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-benchmark
    pytest-mock
    pytest-timeout
    pytest-django
    pydot
  ];

  pytestFlags = [ "--benchmark-disable" ];

  disabledTestPaths = [
    # quite slow
    "tests/test_weighted_transitions.py"
    "tests/scxml/"
  ];

  disabledTests = [
    # broken upstream
    "statemachine.contrib.diagram.quickchart_write_svg"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # async state transitions appear broken on darwin
    # TODO: investigate on an actual macOS machine
    "test_timeout_fires_done_invoke"
    "test_timeout_fires_before_slow_invoke"
    "test_custom_event_fires"
    "test_group_returns_ordered_results"
    "test_group_error_cancels_remaining"
  ];

  pythonImportsCheck = [ "statemachine" ];

  meta = {
    description = "Expressive statecharts and FSMs for modern Python";

    homepage = "https://github.com/fgmacedo/python-statemachine";
    changelog = "https://github.com/fgmacedo/python-statemachine/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kilyanni ];
  };
})
