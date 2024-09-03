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
  version = "0.8.0";
  pyproject = true;
  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "pysal";
    repo = "momepy";
    rev = "v${version}";
    hash = "sha256-r2iGzk54MsrkYB3Sp9/B1QGKnvqPGUj3MQhk6yqIoXE=";
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
    maintainers = lib.teams.geospatial.members;
  };
}
