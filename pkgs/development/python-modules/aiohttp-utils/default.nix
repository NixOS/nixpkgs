{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  python-mimeparse,
  gunicorn,
  mako,
  pytestCheckHook,
  webtest-aiohttp,
}:

buildPythonPackage rec {
  pname = "aiohttp-utils";
  version = "3.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sloria";
    repo = "aiohttp-utils";
    tag = version;
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

  meta = {
    description = "Handy utilities for building aiohttp.web applications";
    homepage = "https://github.com/sloria/aiohttp-utils";
    changelog = "https://github.com/sloria/aiohttp-utils/blob/${src.rev}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
