{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  dash,
  dash-bootstrap-components,
  numpy,
}:

buildPythonPackage rec {
  pname = "dash-bootstrap-templates";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AnnMarieW";
    repo = "dash-bootstrap-templates";
    tag = "V${version}";
    hash = "sha256-B7iyN4sJA6DmoLf3DpFEONDe5tUd4cBlDIH4E7JtULk=";
  };
  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dash
    dash-bootstrap-components
    numpy
  ];

  pythonImportsCheck = [ "dash_bootstrap_templates" ];

  # There are no tests.
  doCheck = false;

  meta = {
    description = "Collection of 52 Plotly figure templates with a Bootstrap theme";
    homepage = "https://github.com/AnnMarieW/dash-bootstrap-templates";
    changelog = "https://github.com/AnnMarieW/dash-bootstrap-templates/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ flokli ];
  };
}
