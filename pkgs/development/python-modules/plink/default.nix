{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  sphinx,
  tkinter,
}:

buildPythonPackage {
  pname = "plink";
  version = "2.4.7-unstable-2026-01-02";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "plink";
    rev = "cab9807897602727f101f9e2bbf68aa6acee1f76";
    hash = "sha256-XTdyfP6rVNJIuvUjo/G6DErnTQdJYHEPbcYrzW7Lz84=";
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
    # changelog = "https://github.com/3-manifolds/PLink/releases/tag/${src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      noiioiu
      alejo7797
    ];
  };
}
