{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyintesishome";
  version = "1.8.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jnimmo";
    repo = "pyIntesisHome";
    tag = finalAttrs.version;
    hash = "sha256-TwZAuu/mnChZwhZ5uGPiQ23curCiqTKWNgDrvwpgojc=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyintesishome" ];

  meta = {
    description = "Python interface for IntesisHome devices";
    homepage = "https://github.com/jnimmo/pyIntesisHome";
    changelog = "https://github.com/jnimmo/pyIntesisHome/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
