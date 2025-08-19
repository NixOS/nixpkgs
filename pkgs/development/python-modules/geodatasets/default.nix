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
  version = "2024.8.0";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "geopandas";
    repo = "geodatasets";
    tag = version;
    hash = "sha256-GJ7RyFlohlRz0RbQ80EewZUmIX9CJkSfUMY/uMNTtEM=";
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
