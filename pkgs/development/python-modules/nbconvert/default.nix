<<<<<<< HEAD
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
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, markupsafe
, mistune
, nbclient
, packaging
, pandocfilters
, pygments
<<<<<<< HEAD
, tinycss2
, traitlets
, importlib-metadata
, flaky
, ipywidgets
, pyppeteer
, pytestCheckHook
=======
, pyppeteer
, pytestCheckHook
, pythonOlder
, tinycss2
, traitlets
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

let
  # see https://github.com/jupyter/nbconvert/issues/1896
  style-css = fetchurl {
    url = "https://cdn.jupyter.org/notebook/5.4.0/style/style.min.css";
    hash = "sha256-WGWmCfRDewRkvBIc1We2GQdOVAoFFaO4LyIvdk61HgE=";
  };
in buildPythonPackage rec {
  pname = "nbconvert";
<<<<<<< HEAD
  version = "7.7.3";

  disabled = pythonOlder "3.8";
=======
  version = "7.2.5";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-SlmWv1880WqgQxiXuhqkxkhCwgefQ0s9xrjEslLvM1U=";
=======
    hash = "sha256-j9xE/X2UJNt/3G4eg0oC9rhiD/tlN2c4i+L56xb4QYQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    flaky
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
