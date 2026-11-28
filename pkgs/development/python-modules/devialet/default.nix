{
  lib,
  aiohttp,
  async-upnp-client,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "devialet";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fwestenberg";
    repo = "devialet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5SOaVPSl3pmCV3t6687e+pjTrOrWV5RiOMW06WYDFaQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    async-upnp-client
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "devialet" ];

  meta = {
    description = "Library to interact with the Devialet API";
    homepage = "https://github.com/fwestenberg/devialet";
    changelog = "https://github.com/fwestenberg/devialet/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
