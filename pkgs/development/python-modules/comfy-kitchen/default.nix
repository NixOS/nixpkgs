{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nanobind,
  setuptools,
  torch,
}:

buildPythonPackage (finalAttrs: {
  pname = "comfy-kitchen";
  version = "0.2.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "comfy-kitchen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u83fTb65wALGzgBZO53UJMEFSm1w727IBhiS5XVEoc4=";
  };

  build-system = [
    nanobind
    setuptools
  ];

  dependencies = [ torch ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "BUILD_NO_CUDA = False" "BUILD_NO_CUDA = True"
  '';

  pythonImportsCheck = [ "comfy_kitchen" ];

  meta = {
    description = "Fast kernel library for ComfyUI with multiple compute backends";
    homepage = "https://github.com/Comfy-Org/comfy-kitchen";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ caniko ];
  };
})
