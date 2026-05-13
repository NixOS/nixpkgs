{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  setuptools,
  aiohttp,
  python-mimeparse,
  gunicorn,
  mako,
  pytestCheckHook,
  webtest-aiohttp,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiohttp-utils";
  version = "3.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sloria";
    repo = "aiohttp-utils";
    tag = finalAttrs.version;
    hash = "sha256-CGKka6nGQ9o4wn6o3YJ3hm8jGbg16NKkCdBA1mKz4bo=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
    python-mimeparse
    gunicorn
  ];

  pythonImportsCheck = [
    "aiohttp_utils"
  ];

  nativeCheckInputs = [
    mako
    pytestCheckHook
    webtest-aiohttp
  ];

  disabledTests = [
    # AssertionError: assert None == 'application/octet-stream'
    "test_renders_to_json_by_default"
  ];

  disabledTestPaths = lib.optionals (pythonAtLeast "3.14") [
    # RuntimeError: There is no current event loop in thread 'MainThread'.
    "tests/test_examples.py"
    "tests/test_negotiation.py"
    "tests/test_routing.py"
  ];

  meta = {
    description = "Handy utilities for building aiohttp.web applications";
    homepage = "https://github.com/sloria/aiohttp-utils";
    changelog = "https://github.com/sloria/aiohttp-utils/tags/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
