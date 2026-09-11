{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  pillow,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioslimproto";
  version = "3.1.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "aioslimproto";
    tag = finalAttrs.version;
    hash = "sha256-IyDgnBQC8EbDzwRFWgmVOf4lVNsmdiTaMfpWXHUa4oM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${finalAttrs.version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    async-timeout
    pillow
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "aioslimproto" ];

  meta = {
    description = "Module to control Squeezebox players";
    homepage = "https://github.com/home-assistant-libs/aioslimproto";
    changelog = "https://github.com/home-assistant-libs/aioslimproto/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
