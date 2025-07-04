{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  yarl,
  aresponses,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "directv";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ctalkington";
    repo = "python-directv";
    tag = version;
    hash = "sha256-s4bE8ACFCfpNq+HGEO8fv3VCGPI4OOdR5A7RjY2bTKY=";
  };

  postPatch = ''
    # TypeError: 'Timeout' object does not support the context manager protocol
    substituteInPlace directv/directv.py \
      --replace-fail "with async_timeout.timeout" "async with async_timeout.timeout"
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  disabledTests = [
    #  ValueError: Host '#' cannot contain '#' (at position 0)
    "test_client_error"
  ];

  pythonImportsCheck = [ "directv" ];

  meta = {
    changelog = "https://github.com/ctalkington/python-directv/releases/tag/${src.tag}";
    description = "Asynchronous Python client for DirecTV (SHEF)";
    homepage = "https://github.com/ctalkington/python-directv";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
