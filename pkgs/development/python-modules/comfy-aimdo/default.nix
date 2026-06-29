{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,
  setuptools-scm,

  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "comfy-aimdo";
  version = "0.4.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "comfy-aimdo";
    tag = "v${version}";
    hash = "sha256-57z8NrEabc0RrTJavbdbpOZSLkNarPA2D+hZ+WUS4r4=";
  };
  build-system = [
    setuptools
    setuptools-scm
  ];

  # TODO: build libs for cuda aimdo

  pythonImportsCheck = [ "comfy_aimdo" ];

  meta = {
    description = "AI Model Demand Offloading Allocator";
    homepage = "https://github.com/Comfy-Org/comfy-aimdo/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      jk
    ];
  };
}
