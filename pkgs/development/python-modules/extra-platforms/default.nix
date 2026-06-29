{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "extra-platforms";
  version = "12.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kdeldycke";
    repo = "extra-platforms";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OJ5ch1dfAnblC+3UCJ9I9P9sw8taGp8yBg//ZraunRo=";
  };

  build-system = [ uv-build ];

  nativeCheckInputs = [
    pytestCheckHook
    # Used by tests that exercise URL-fetching helpers.
    requests
  ];

  # Tests marked ``network`` reach out to PyPI; the build sandbox has
  # no system TLS CA bundle.
  disabledTestMarks = [ "network" ];

  disabledTestPaths = [
    # Shells out to ``uv`` to render the docs as a side effect; not
    # available in the build sandbox.
    "tests/test_sphinx_crossrefs.py"
  ];

  disabledTests = [
    # Both tests assume the CI runner environment (the ``GITHUB_RUNNER_OS``
    # env var, the expected number of detected platform traits per runner
    # image). Neither is available inside a hermetic build sandbox.
    "test_platform_detection"
    "test_current_funcs"
  ];

  pythonImportsCheck = [ "extra_platforms" ];

  meta = {
    description = "Detect platforms, architectures and OS families";
    homepage = "https://github.com/kdeldycke/extra-platforms";
    changelog = "https://github.com/kdeldycke/extra-platforms/blob/v${finalAttrs.version}/changelog.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kdeldycke ];
  };
})
