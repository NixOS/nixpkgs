{
  lib,
  aiofiles,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  rich,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyporscheconnectapi";
  version = "0.2.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CJNE";
    repo = "pyporscheconnectapi";
    tag = finalAttrs.version;
    hash = "sha256-J3pIxaOa1ZWOnFBqEQs0NRxN/RH9viEk2Af2xNfDV0k=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"pytest-runner"' ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    beautifulsoup4
    httpx
    rich
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyporscheconnectapi" ];

  meta = {
    description = "Python client library for Porsche Connect API";
    homepage = "https://github.com/CJNE/pyporscheconnectapi";
    changelog = "https://github.com/CJNE/pyporscheconnectapi/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
