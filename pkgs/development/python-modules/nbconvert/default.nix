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
  version = "6.5.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EO1pPEz9PGNYPIfKXDovbth0FFEDWV84JO/Mjfy3Uiw=";
  };

  # Add $out/share/jupyter to the list of paths that are used to search for
  # various exporter templates
  patches = [
    ./templates.patch

    # Use mistune 2.x
    (fetchpatch {
      name = "support-mistune-2.x.patch";
      url = "https://github.com/jupyter/nbconvert/commit/e870d9a4a61432a65bee5466c5fa80c9ee28966e.patch";
      hash = "sha256-kdOmE7BnkRy2lsNQ2OVrEXXZntJUPJ//b139kSsfKmI=";
      excludes = [ "pyproject.toml" ];
    })
  ];

  postPatch = ''
    substituteAllInPlace ./nbconvert/exporters/templateexporter.py

    # Use mistune 2.x
    substituteInPlace setup.py \
        --replace "mistune>=0.8.1,<2" "mistune>=2.0.3,<3"
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
