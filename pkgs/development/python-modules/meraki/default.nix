{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  jinja2,
  poetry-core,
  pytest,
  requests,
  setuptools,
  wheel,
}:

buildPythonPackage (finalAttrs: {
  pname = "meraki";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "meraki";
    repo = "dashboard-api-python";
    tag = finalAttrs.version;
    hash = "sha256-+PlNTlN+fNFdCqyVRZuU+mN1G2cLdlHs2jJJs0PODFI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=78.1.1,<79.0.0" "setuptools" \
      --replace-fail "wheel>=0.46.2" "wheel"
  '';

  pythonRelaxDeps = [
    "pytest"
    "setuptools"
  ];

  build-system = [
    poetry-core
    setuptools
    wheel
  ];

  dependencies = [
    aiohttp
    jinja2
    pytest
    requests
    setuptools
  ];

  # All tests require an API key
  doCheck = false;

  pythonImportsCheck = [ "meraki" ];

  meta = {
    description = "Cisco Meraki cloud-managed platform dashboard API python library";
    homepage = "https://github.com/meraki/dashboard-api-python";
    changelog = "https://github.com/meraki/dashboard-api-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dylanmtaylor ];
  };
})
