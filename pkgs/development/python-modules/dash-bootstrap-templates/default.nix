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
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AnnMarieW";
    repo = "dash-bootstrap-templates";
    tag = "V${version}";
    hash = "sha256-GYL8shd8B5kdBhjurirtAMBIbPyQNbZL4+3WyTn2Qsw=";
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
