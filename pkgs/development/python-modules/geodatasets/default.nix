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
  version = "2026.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "geopandas";
    repo = "geodatasets";
    tag = version;
    hash = "sha256-Kh1Cvjlfq+GAPhYPjQCNt8mHJFeSrdUfg74NoSQm618=";
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
