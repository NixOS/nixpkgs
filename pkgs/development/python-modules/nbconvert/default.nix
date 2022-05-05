{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, glibcLocales
, entrypoints
, bleach
, mistune
, nbclient
, jinja2
, pygments
, traitlets
, jupyter_core
, jupyterlab-pygments
, nbformat
, ipykernel
, pandocfilters
, tornado
, jupyter-client
, defusedxml
, tinycss2
, beautifulsoup4
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

  checkInputs = [ pytestCheckHook glibcLocales ];

  propagatedBuildInputs = [
    entrypoints bleach mistune jinja2 pygments traitlets
    jupyter_core nbformat ipykernel pandocfilters tornado jupyter-client
    defusedxml tinycss2 beautifulsoup4
    nbclient
    jupyterlab-pygments
  ];

  # disable preprocessor tests for ipython 7
  # see issue https://github.com/jupyter/nbconvert/issues/898
  preCheck = ''
    export LC_ALL=en_US.UTF-8
    HOME=$(mktemp -d)
  '';

  pytestFlagsArray = [
    "--ignore=nbconvert/preprocessors/tests/test_execute.py"
    # can't resolve template paths within sandbox
    "--ignore=nbconvert/tests/base.py"
    "--ignore=nbconvert/tests/test_nbconvertapp.py"
  ];


  disabledTests = [
    "test_export"
    "test_webpdf_without_chromium"
    #"test_cell_tag_output"
    #"test_convert_from_stdin"
    #"test_convert_full_qualified_name"
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
