{ lib
, fetchurl
, buildPythonPackage
, pythonOlder
, fetchPypi
, hatchling
, beautifulsoup4
, bleach
, defusedxml
, jinja2
, jupyter-core
, jupyterlab-pygments
, markupsafe
, mistune
, nbclient
, packaging
, pandocfilters
, pygments
, tinycss2
, traitlets
, importlib-metadata
, flaky
, ipywidgets
, pyppeteer
, pytestCheckHook
}:

let
  # see https://github.com/jupyter/nbconvert/issues/1896
  style-css = fetchurl {
    url = "https://cdn.jupyter.org/notebook/5.4.0/style/style.min.css";
    hash = "sha256-WGWmCfRDewRkvBIc1We2GQdOVAoFFaO4LyIvdk61HgE=";
  };
in buildPythonPackage rec {
  pname = "nbconvert";
  version = "7.7.3";

  disabled = pythonOlder "3.8";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SlmWv1880WqgQxiXuhqkxkhCwgefQ0s9xrjEslLvM1U=";
  };

  # Add $out/share/jupyter to the list of paths that are used to search for
  # various exporter templates
  patches = [
    ./templates.patch
  ];

  postPatch = ''
    substituteAllInPlace ./nbconvert/exporters/templateexporter.py

    mkdir -p share/templates/classic/static
    cp ${style-css} share/templates/classic/static/style.css
  '';

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    beautifulsoup4
    bleach
    defusedxml
    jinja2
    jupyter-core
    jupyterlab-pygments
    markupsafe
    mistune
    nbclient
    packaging
    pandocfilters
    pygments
    tinycss2
    traitlets
  ] ++ lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  nativeCheckInputs = [
    flaky
    ipywidgets
    pyppeteer
    pytestCheckHook
  ];

  disabledTests = [
    # Attempts network access (Failed to establish a new connection: [Errno -3] Temporary failure in name resolution)
    "test_export"
    "test_webpdf_with_chromium"
    # ModuleNotFoundError: No module named 'nbconvert.tests'
    "test_convert_full_qualified_name"
    "test_post_processor"
  ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Converting Jupyter Notebooks";
    homepage = "https://jupyter.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
