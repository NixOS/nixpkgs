{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  sphinx,
  tkinter,
}:

buildPythonPackage rec {
  pname = "plink";
  version = "2.4.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "plink";
    tag = "${version}_as_released";
    hash = "sha256-+WUyQvQY9Fx47GikzJ4gcCpSIjvk5756FP0bDdF6Ack=";
  };

  build-system = [
    setuptools
    sphinx
  ];

  dependencies = [ tkinter ];

  pythonImportsCheck = [ "plink" ];

  meta = {
    description = "Full featured Tk-based knot and link editor";
    mainProgram = "plink";
    homepage = "https://3-manifolds.github.io/PLink";
    changelog = "https://github.com/3-manifolds/PLink/releases/tag/${src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ noiioiu ];
  };
}
