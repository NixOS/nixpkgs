{ lib
, fetchPypi
, buildPythonPackage
, matplotlib
, scipy
, patsy
, pandas
, statsmodels
, pytestCheckHook
, geopandas
, scikit-misc
, adjusttext
, mizani }:

buildPythonPackage rec {
  pname = "plotnine";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-DompMBXzxx1oRKx6qfsNoJuQj199+n3V1opcoysuvOo=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=plotnine --cov-report=xml" ""
  '';

  buildInputs = [
    matplotlib
    mizani
    pandas
    patsy
    scipy
    statsmodels
  ];

  checkInputs = [
    adjusttext
    geopandas
    pytestCheckHook
    scikit-misc
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [
    "plotnine"
  ];

  disabledTestPaths = [
    # Assertion Errors
    "tests/test_theme.py"
    "tests/test_scale_internals.py"
    "tests/test_scale_labelling.py"
    "tests/test_position.py"
    "tests/test_geom_text_label.py"
    "tests/test_geom_smooth.py"
    "tests/test_geom_segment.py"
    "tests/test_geom_ribbon_area.py"
    "tests/test_geom_map.py"
    "tests/test_facets.py"
    "tests/test_facet_labelling.py"
    "tests/test_coords.py"
    "tests/test_annotation_logticks.py"
  ];

  meta = with lib; {
    description = "Grammar of graphics for python";
    homepage = "https://plotnine.readthedocs.io/en/stable";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
