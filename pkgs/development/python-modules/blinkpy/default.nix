{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
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
  version = "0.23.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fronzbot";
    repo = "blinkpy";
    rev = "refs/tags/v${version}";
    hash = "sha256-MWXOxE0nxBFhkAWjy7qFPhv4AO6VjGf+fAiyaWXeiX8=";
  };

  patches = [
    (fetchpatch2 {
      # Fix tests with aiohttp 3.10+
      url = "https://github.com/fronzbot/blinkpy/commit/e2c747b5ad295424b08ff4fb03204129155666fc.patch";
      hash = "sha256-FapgAZcKBWqtAPjRl2uOFgnYPoWq6UU88XGLO7oCmDI=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace ', "wheel~=0.40.0"' "" \
      --replace "setuptools~=68.0" "setuptools"
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

  meta = with lib; {
    description = "Python library for the Blink Camera system";
    homepage = "https://github.com/fronzbot/blinkpy";
    changelog = "https://github.com/fronzbot/blinkpy/blob/${src.rev}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
