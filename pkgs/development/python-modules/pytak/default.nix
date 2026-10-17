{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cryptography,
  aiohttp,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytak";
  version = "7.3.10";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "snstac";
    repo = "pytak";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LHiIRNVasgeKXqPPyYZ9TUbZYqatPxbkp904NRzXOlA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    aiohttp
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTests = [
    # require network access -> Network is unreachable
    "test_protocol_factory_udp_multicast"
    "test_protocol_factory_udp_multicast_wo"
    "test_protocol_factory_udp_multicast_ro"
  ];

  pythonImportsCheck = [ "pytak" ];

  meta = {
    description = "Python package for rapid Team Awareness Kit (TAK) integration";
    homepage = "https://pytak.readthedocs.io";
    changelog = "https://github.com/snstac/pytak/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
  };
})
