{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "comfy-aimdo";
  version = "0.2.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "comfy-aimdo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jmBVUwQkd6ceLVx1ZSNiByx1vZF+Al7/jmgz0sy+B/E=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  # Upstream ships no test suite at this tag.
  doCheck = false;

  pythonImportsCheck = [ "comfy_aimdo.control" ];

  meta = {
    description = "AI model dynamic offloader for ComfyUI";
    homepage = "https://github.com/Comfy-Org/comfy-aimdo";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ caniko ];
  };
})
