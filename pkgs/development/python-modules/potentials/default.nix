{
  lib,
  bibtexparser,
  buildPythonPackage,
  cdcs,
  datamodeldict,
  fetchFromGitHub,
  fetchPypi,
  habanero,
  ipywidgets,
  lxml,
  matplotlib,
  numpy,
  pandas,
  requests,
  scipy,
  unidecode,
  uv-build,
  xmltodict,
  yabadaba,
}:

buildPythonPackage (finalAttrs: {
  pname = "potentials";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = "potentials";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GGEpxp0ww8Ridiol5xqAYA6zXUFnOGiMvka49nlJHEU=";
  };

  build-system = [ uv-build ];

  dependencies = [
    bibtexparser
    cdcs
    datamodeldict
    habanero
    ipywidgets
    lxml
    matplotlib
    numpy
    pandas
    requests
    scipy
    unidecode
    xmltodict
    yabadaba
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "potentials" ];

  meta = {
    description = "Python API database tools for accessing the NIST Interatomic Potentials Repository";
    homepage = "https://github.com/usnistgov/potentials";
    changelog = "https://github.com/usnistgov/potentials/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
