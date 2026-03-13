{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "loqedapi";
  version = "2.1.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cpolhout";
    repo = "loqedAPI";
    tag = "v${version}";
    hash = "sha256-IYzrGqql6mmm+FmasxFJvKgHvg7n81WOu+GGAEQ1+Os=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [ "loqedAPI" ];

  meta = {
    description = "Module to interact with the Loqed Smart Door Lock API";
    homepage = "https://github.com/cpolhout/loqedAPI";
    changelog = "https://github.com/cpolhout/loqedAPI/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
}
