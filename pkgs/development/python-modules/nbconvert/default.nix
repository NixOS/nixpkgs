{ beautifulsoup4
, bleach
, buildPythonPackage
, defusedxml
, entrypoints
, fetchPypi
, ipykernel
, ipywidgets
, jinja2
, jupyter_core
, jupyter-client
, jupyterlab-pygments
, lib
, mistune
, nbclient
, nbformat
, pandocfilters
, pygments
, pyppeteer
, pytestCheckHook
, testpath
, tinycss2
, tornado
, traitlets
}:

buildPythonPackage rec {
  pname = "nbconvert";
  version = "6.5.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ij5G4nq+hZa4rtVDAfrbukM7f/6oGWpo/Xsf9Qnu6Z0=";
  };

  # Add $out/share/jupyter to the list of paths that are used to search for
  # various exporter templates
  patches = [
    ./templates.patch
  ];

  postPatch = ''
    substituteAllInPlace ./nbconvert/exporters/templateexporter.py
  '';

  propagatedBuildInputs = [
    (nbclient.override { doCheck = false; }) # avoid infinite recursion
    beautifulsoup4
    bleach
    defusedxml
    entrypoints
    ipykernel
    jinja2
    jupyter_core
    jupyter-client
    jupyterlab-pygments
    mistune
    nbformat
    pandocfilters
    pygments
    testpath
    tinycss2
    tornado
    traitlets
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  checkInputs = [
    ipywidgets
    pyppeteer
    pytestCheckHook
  ];

  pytestFlagsArray = [
    # DeprecationWarning: Support for bleach <5 will be removed in a future version of nbconvert
    "-W ignore::DeprecationWarning"
  ];

  disabledTests = [
    # Attempts network access (Failed to establish a new connection: [Errno -3] Temporary failure in name resolution)
    "test_export"
    "test_webpdf_with_chromium"
  ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Converting Jupyter Notebooks";
    homepage = "https://jupyter.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
  };
}
