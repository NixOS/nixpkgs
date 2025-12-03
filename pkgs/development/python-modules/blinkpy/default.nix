{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiofiles,
  aiohttp,
  pytest-asyncio,
  pytestCheckHook,
  python-dateutil,
  python-slugify,
  pythonOlder,
  requests,
  setuptools,
  sortedcontainers,
}:

buildPythonPackage rec {
  pname = "blinkpy";
  version = "0.24.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fronzbot";
    repo = "blinkpy";
    tag = "v${version}";
    hash = "sha256-UjkVpXqGOOwtpBslQB61osaQvkuvD4A+xeUrMpyWetg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "wheel~=0.40.0" wheel \
      --replace-fail "setuptools>=68,<81" setuptools
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    aiofiles
    aiohttp
    python-dateutil
    python-slugify
    requests
    sortedcontainers
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "blinkpy"
    "blinkpy.api"
    "blinkpy.auth"
    "blinkpy.blinkpy"
    "blinkpy.camera"
    "blinkpy.helpers.util"
    "blinkpy.sync_module"
  ];

  meta = {
    description = "Python library for the Blink Camera system";
    homepage = "https://github.com/fronzbot/blinkpy";
    changelog = "https://github.com/fronzbot/blinkpy/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
