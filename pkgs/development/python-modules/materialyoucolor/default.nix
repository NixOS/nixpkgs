{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,
  pybind11,

  pillow,

  psutil,
  rich,
}:

buildPythonPackage (finalAttrs: {
  pname = "materialyoucolor";
  version = "3.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "T-Dynamos";
    repo = "materialyoucolor-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wD6Vh0Ao+zq8FmUXcBaJYGcdw+hCk8lZ2FvODhwJBCE=";
  };

  build-system = [
    setuptools
    pybind11
  ];

  dependencies = [
    pillow
  ];

  nativeCheckInputs = [
    psutil
    rich
  ];

  checkPhase = ''
    runHook preCheck

    # test script taken from .github/workflows/cibuildwheel.yml
    python -c "from PIL import Image; Image.new('RGB', (128, 128), (70, 120, 180)).save('test_image.jpg')"
    python tests/test_all.py --image test_image.jpg --quality 1 --method pillow --tonal-spot
    python tests/test_all.py --image test_image.jpg --quality 1 --method cpp --tonal-spot

    runHook postCheck
  '';

  pythonImportsCheck = [
    "materialyoucolor"
    "materialyoucolor.quantize" # ext
  ];

  meta = {
    description = "Material You color generation algorithms in python";
    homepage = "https://github.com/T-Dynamos/materialyoucolor-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
})
