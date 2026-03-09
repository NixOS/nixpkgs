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
  version = "0.2.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "comfy-aimdo";
    tag = "v${version}";
    hash = "sha256-MO0YRaCZugGKqsfZs01XFjklXWjQrsSHDzFt5f2J/tQ=";
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
