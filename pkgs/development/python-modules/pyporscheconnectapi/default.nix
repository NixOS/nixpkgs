{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  rich,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyporscheconnectapi";
  version = "0.2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CJNE";
    repo = "pyporscheconnectapi";
    tag = finalAttrs.version;
    hash = "sha256-aiNCT1IYSXdlJfIoQsBnVn9FGHifkI8e35VCQGGAAZ0=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"pytest-runner"' ""
  '';

  build-system = [ setuptools ];

  dependencies = [
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
