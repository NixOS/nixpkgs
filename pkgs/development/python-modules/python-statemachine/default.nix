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
  docutils,
  pyyaml,
  jsonschema,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-statemachine";
  version = "3.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "python_statemachine";
    inherit (finalAttrs) version;
    hash = "sha256-RLmMubsQgYke9u+pB8gh0FyuUxSiuZcT5W1Wqcli3gg=";
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
    docutils
    pyyaml
    jsonschema
  ];

  pytestFlags = [ "--benchmark-disable" ];

  disabledTestPaths = [
    # quite slow
    "tests/test_weighted_transitions.py"
    "tests/scxml/"

    # requires sphinx, which is not worth pulling in for this relatively low-signal test
    "statemachine/contrib/diagram/sphinx_ext.py"
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

    # flaky
    "test_group_returns_ordered_results"
    "test_group_error_cancels_remaining"
    "test_group_with_file_io"
    "test_group_cancel_on_exit"
    "test_group_single_callable"
    "test_each_sm_instance_gets_own_group"
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
