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
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AnnMarieW";
    repo = "dash-bootstrap-templates";
    rev = "V${version}";
    hash = "sha256-dbXqqncxfIZ6traVQ2a/2E1Co4MVdoiU8ox6nBnqviE=";
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
    description = "A collection of 52 Plotly figure templates with a Bootstrap theme";
    homepage = "https://github.com/AnnMarieW/dash-bootstrap-templates";
    changelog = "https://github.com/AnnMarieW/dash-bootstrap-templates/releases/tag/V${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ flokli ];
  };
}
