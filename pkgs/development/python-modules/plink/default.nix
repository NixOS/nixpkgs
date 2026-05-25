{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  sphinx,
  tkinter,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "plink";
  version = "2.4.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "plink";
    tag = "${version}_as_released";
    hash = "sha256-+O371oWfvRvMfjXX6qZj91c7+4MBneZFNcfdrJQNCY8=";
  };

  build-system = [
    setuptools
    sphinx
  ];

  dependencies = [ tkinter ];

  pythonImportsCheck = [ "plink" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "(.*)_as_released"
    ];
  };

  meta = {
    description = "Full featured Tk-based knot and link editor";
    mainProgram = "plink";
    homepage = "https://3-manifolds.github.io/PLink";
    changelog = "https://github.com/3-manifolds/PLink/releases/tag/${src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      noiioiu
      alejo7797
    ];
  };
}
