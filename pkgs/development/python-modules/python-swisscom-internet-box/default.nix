{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-swisscom-internet-box";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anatosun";
    repo = "python-swisscom-internet-box";
    tag = "v${finalAttrs.version}";
    hash = "sha256-37F6Ld8oOmqEufYIujkjkxHqfzzgWHrxIqIga53r6xU=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  pythonImportsCheck = [ "swisscom_internet_box" ];

  meta = {
    description = "Python client for the Swisscom Internet-Box";
    homepage = "https://github.com/anatosun/python-swisscom-internet-box";
    changelog = "https://github.com/anatosun/python-swisscom-internet-box/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
