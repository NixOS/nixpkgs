{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pyprojectVersionPatchHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "mvcrender";
  version = "0.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sca075";
    repo = "mvcrender";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7DFPZPzGR21yFpwTKcBhO9F+Lpc9pqJmAioawQLDdPM=";
  };

  build-system = [
    numpy
    setuptools
  ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [ numpy ];

  # The repository only contains manual tests
  doCheck = false;

  pythonImportsCheck = [
    "mvcrender"
    "mvcrender.autocrop"
    "mvcrender.blend"
    "mvcrender.draw"
    "mvcrender.material"
    "mvcrender.rooms"
  ];

  meta = {
    description = "High-performance C extensions for image processing";
    homepage = "https://github.com/sca075/mvcrender";
    changelog = "https://github.com/sca075/mvcrender/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
