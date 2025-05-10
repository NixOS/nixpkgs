{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  qtpy,
  pyvista,
}:

buildPythonPackage rec {
  version = "0.11.2";
  pname = "pyvistaqt";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyvista";
    repo = "pyvistaqt";
    tag = version;
    hash = "sha256-B8NyJVEYzqUAG2zi/YuowpRhbHUNprPA0F6Uh2hYsF0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    qtpy
    pyvista
  ];

  pythonImportsCheck = [ "pyvistaqt" ];

  # Qt related tests cannot run in sandbox
  # Fatal Python error: Aborted
  doCheck = false;

  meta = {
    homepage = "http://qtdocs.pyvista.org/";
    downloadPage = "https://github.com/pyvista/pyvistaqt";
    description = "Pyvista Qt Plotter";
    changelog = "https://github.com/pyvista/pyvistaqt/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
