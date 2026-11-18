{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "openrgb-python";
  version = "0.3.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jath03";
    repo = "openrgb-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AncGoP4M++lkjGUw+3wGx2bGajqeCPB7hZWf0dAcCSE=";
  };

  build-system = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "openrgb" ];

  meta = {
    description = "Module for the OpenRGB SDK";
    homepage = "https://openrgb-python.readthedocs.io/";
    changelog = "https://github.com/jath03/openrgb-python/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
