{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyrisco";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OnFreund";
    repo = "pyrisco";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tzCwimkSLazD6LtimFUcRjOvnvSlYY1MpJLZ2u4WgUg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ aiohttp ];

  # All tests require cloud access
  doCheck = false;

  pythonImportsCheck = [ "pyrisco" ];

  meta = {
    description = "Python interface to Risco alarm systems through Risco Cloud";
    homepage = "https://github.com/OnFreund/pyrisco";
    changelog = "https://github.com/OnFreund/pyrisco/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
