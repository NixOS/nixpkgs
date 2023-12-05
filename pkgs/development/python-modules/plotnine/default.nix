{ lib
, adjusttext
, buildPythonPackage
, fetchPypi
, geopandas
, matplotlib
, mizani
, pandas
, patsy
, pytestCheckHook
, pythonOlder
, scikit-misc
, scipy
, setuptools-scm
, statsmodels
}:

buildPythonPackage rec {
  pname = "plotnine";
  version = "0.12.3";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-o43LNgf8ADweWa4MnVNdrngXZQ0cvC5W5W5bPeiN/pk=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=plotnine --cov-report=xml" ""
  '';

  propagatedBuildInputs = [
    matplotlib
    mizani
    pandas
    patsy
    scipy
    statsmodels
  ];

  nativeCheckInputs = [
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
    homepage = "https://plotnine.readthedocs.io/";
    changelog = "https://github.com/has2k1/plotnine/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
