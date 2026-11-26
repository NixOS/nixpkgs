{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build
  hatchling,
  pytest,

  # dependencies
  packaging,

  # check
  pytestCheckHook,
  pytest-xdist,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-check";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "okken";
    repo = "pytest-check";
    tag = finalAttrs.version;
    hash = "sha256-iMjBar6JsAzZiezMXf+zP+gQ7b3kwI/I3718niUSEnw=";
  };

  build-system = [ hatchling ];

  buildInputs = [ pytest ];

  dependencies = [ packaging ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  disabledTests = [
    # Fails on output differences
    "test_raises_custom_msg"
    "test_message"
    # assert {} == {3: 3, 5: 5} (a/k/a racy)
    "test_concurrent_check_failures_are_tracked_per_thread"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # AssertionError: assert '99' not in '===========...============'
    "test_long_locals_follow_verbosity"
  ];

  pythonImportsCheck = [ "pytest_check" ];

  meta = {
    description = "Pytest plugin allowing multiple failures per test";
    homepage = "https://github.com/okken/pytest-check";
    changelog = "https://github.com/okken/pytest-check/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      flokli
      sarahec
    ];
  };
})
