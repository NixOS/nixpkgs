{ beautifulsoup4
, bleach
, buildPythonPackage
, defusedxml
, fetchPypi
, fetchpatch
, fetchurl
, hatchling
, importlib-metadata
, ipywidgets
, jinja2
, jupyter_core
, jupyterlab-pygments
, lib
, markupsafe
, mistune
, nbclient
, packaging
, pandocfilters
, pygments
, pyppeteer
, pytestCheckHook
, pythonOlder
, tinycss2
, traitlets
}:

let
  # see https://github.com/jupyter/nbconvert/issues/1896
  style-css = fetchurl {
    url = "https://cdn.jupyter.org/notebook/5.4.0/style/style.min.css";
    hash = "sha256-WGWmCfRDewRkvBIc1We2GQdOVAoFFaO4LyIvdk61HgE=";
  };
in buildPythonPackage rec {
  pname = "nbconvert";
  version = "7.2.3";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eufMxoSVtWXasVNFnufmUDmXCRPrEVBw2m4sZzzw6fg=";
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
    jupyter_core
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

  checkInputs = [
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
