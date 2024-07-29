{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,

  geopandas,
  pooch,
  pyogrio,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "geodatasets";
  version = "2024.7.0";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "geopandas";
    repo = "geodatasets";
    rev = "refs/tags/${version}";
    hash = "sha256-DNM3DUtj+hfwiqjnCf3OSiSuuf1AbFnyCN9KPDBisyU=";
  };

  build-system = [ setuptools-scm ];

  propagatedBuildInputs = [ pooch ];

  nativeCheckInputs = [
    geopandas
    pyogrio
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  pytestFlagsArray = [
    # disable tests which require network access
    "-m 'not request'"
  ];

  pythonImportsCheck = [ "geodatasets" ];

  meta = {
    description = "Spatial data examples";
    homepage = "https://geodatasets.readthedocs.io/";
    license = lib.licenses.bsd3;
    maintainers = lib.teams.geospatial.members;
  };
}
