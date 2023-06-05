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
, jupyter-core
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

buildPythonPackage rec {
  pname = "nbconvert";
  version = "7.4.0";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UbbHe1B7F3tz9nKduhVnbkLE6SvLAO3IzJgu5y59idc=";
  };

  # Add $out/share/jupyter to the list of paths that are used to search for
  # various exporter templates
  patches = [
    ./templates.patch
  ];

  postPatch = ''
    substituteAllInPlace ./nbconvert/exporters/templateexporter.py
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
