{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mill-local";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyMillLocal";
    tag = version;
    hash = "sha256-t6nZ6KXX5GFIcdNIXyFxYtSjOuuUJmCekaBITNgcIkU=";
  };

  buildInputs = [ setuptools ];

  dependencies = [
    aiohttp
    async-timeout
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "mill_local" ];

  meta = {
    description = "Python module to communicate locally with Mill heaters";
    homepage = "https://github.com/Danielhiversen/pyMillLocal";
    changelog = "https://github.com/Danielhiversen/pyMillLocal/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
