{
  lib,
  aiohttp,
  aiounittest,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyfronius";
  version = "0.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nielstron";
    repo = "pyfronius";
    tag = finalAttrs.version;
    hash = "sha256-KUO5e3UYIm49kgBxidizt77AplojOv4UsnIoDa0Gtv4=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyfronius" ];

  meta = {
    description = "Python module to communicate with Fronius Symo";
    homepage = "https://github.com/nielstron/pyfronius";
    changelog = "https://github.com/nielstron/pyfronius/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
