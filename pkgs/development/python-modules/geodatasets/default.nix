{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,

  geopandas,
  pooch,
  pyogrio,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "geodatasets";
  version = "2026.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "geopandas";
    repo = "geodatasets";
    tag = version;
    hash = "sha256-fLhlXuqcArMb0PtFCKKqL78Z5A/j33Fzov8fg7PGvaQ=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ pooch ];

  nativeCheckInputs = [
    geopandas
    pyogrio
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTestMarks = [
    # disable tests which require network access
    "request"
  ];

  pythonImportsCheck = [ "geodatasets" ];

  meta = {
    description = "Spatial data examples";
    homepage = "https://geodatasets.readthedocs.io/";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.geospatial ];
  };
}
