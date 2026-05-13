{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    # https://github.com/ctalkington/python-directv/pull/365
    (fetchpatch {
      name = "replace-async-timeout-with-asyncio.timeout.patch";
      url = "https://github.com/ctalkington/python-directv/commit/a161454b09e144de15883d25378fbb13069e241b.patch";
      hash = "sha256-jI+ALoQ0EDUQCSQp90SE+e3sGMWLwojNtLevAbgoScc=";
    })
  ];

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
