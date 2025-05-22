{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,

  geopandas,
  inequality,
  libpysal,
  mapclassify,
  networkx,
  packaging,
  pandas,
  setuptools-scm,
  shapely,
  tqdm,
}:

buildPythonPackage rec {
  pname = "momepy";
  version = "0.10.0";
  pyproject = true;
  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "pysal";
    repo = "momepy";
    tag = "v${version}";
    hash = "sha256-9A1g2WSH1kIXO/BeF8ebcigshfcR8MrT2Ut5K/oxVM4=";
  };

  build-system = [ setuptools-scm ];

  propagatedBuildInputs = [
    geopandas
    inequality
    libpysal
    mapclassify
    networkx
    packaging
    pandas
    shapely
    tqdm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "momepy" ];

  meta = {
    description = "Urban Morphology Measuring Toolkit";
    homepage = "https://github.com/pysal/momepy";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.geospatial ];
  };
}
