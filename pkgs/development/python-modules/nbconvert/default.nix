{ beautifulsoup4
, bleach
, buildPythonPackage
, defusedxml
, fetchPypi
, fetchpatch
, ipywidgets
, jinja2
, jupyterlab-pygments
, lib
, markupsafe
, mistune
, nbclient
, pandocfilters
, pyppeteer
, pytestCheckHook
, tinycss2
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
    (fetchpatch {
      name = "fix-test-default-config-jupyter-core-4.11.2.patch";
      url = "https://github.com/jupyter/nbconvert/commit/7227d68acde5e3f2959dd5f4db30af1ee4b222b7.patch";
      hash = "sha256-hrPgvTubig7grEo0F9QIcfxaz5X3p/C2U7Gnhp/uTWY=";
    })
  ];

  postPatch = ''
    substituteAllInPlace ./nbconvert/exporters/templateexporter.py
  '';

  propagatedBuildInputs = [
    beautifulsoup4
    bleach
    defusedxml
    jinja2
    jupyterlab-pygments
    markupsafe
    mistune
    nbclient
    pandocfilters
    tinycss2
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

  meta = {
    description = "Converting Jupyter Notebooks";
    homepage = "https://jupyter.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
