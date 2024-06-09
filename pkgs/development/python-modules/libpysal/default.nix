{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,

  beautifulsoup4,
  fiona,
  geodatasets,
  geopandas,
  numpy,
  packaging,
  pandas,
  platformdirs,
  requests,
  scikit-learn,
  scipy,
  setuptools-scm,
  shapely,
}:

buildPythonPackage rec {
  pname = "libpysal";
  version = "4.10";
  pyproject = true;
  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "pysal";
    repo = "libpysal";
    rev = "v${version}";
    hash = "sha256-jzSkIFSIXc039KR4fS1HOI/Rj0mHwbArn2hD+zfAZDg=";
  };

  build-system = [ setuptools-scm ];

  propagatedBuildInputs = [
    beautifulsoup4
    fiona
    geopandas
    numpy
    packaging
    pandas
    platformdirs
    requests
    scikit-learn
    scipy
    shapely
  ];

  nativeCheckInputs = [
    geodatasets
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  # requires network access
  disabledTestPaths = [
    "libpysal/cg/tests/test_geoJSON.py"
    "libpysal/examples/tests/test_available.py"
    "libpysal/graph/tests/test_base.py"
    "libpysal/graph/tests/test_builders.py"
    "libpysal/graph/tests/test_contiguity.py"
    "libpysal/graph/tests/test_kernel.py"
    "libpysal/graph/tests/test_matching.py"
    "libpysal/graph/tests/test_plotting.py"
    "libpysal/graph/tests/test_triangulation.py"
    "libpysal/graph/tests/test_utils.py"
    "libpysal/graph/tests/test_set_ops.py"
    "libpysal/weights/tests/test_contiguity.py"
    "libpysal/weights/tests/test_util.py"
  ];

  pythonImportsCheck = [ "libpysal" ];

  meta = {
    description = "Library of spatial analysis functions";
    homepage = "https://pysal.org/libpysal/";
    license = lib.licenses.bsd3;
    maintainers = lib.teams.geospatial.members;
  };
}
