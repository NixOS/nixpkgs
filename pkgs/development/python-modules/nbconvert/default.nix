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
, testpath
, jupyter_core
, jupyterlab-pygments
, nbformat
, ipykernel
, pandocfilters
, tornado
, jupyter_client
, defusedxml
}:

buildPythonPackage rec {
  pname = "nbconvert";
  version = "6.0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cbbc13a86dfbd4d1b5dee106539de0795b4db156c894c2c5dc382062bbc29002";
  };

  checkInputs = [ pytestCheckHook glibcLocales ];

  propagatedBuildInputs = [
    entrypoints bleach mistune jinja2 pygments traitlets testpath
    jupyter_core nbformat ipykernel pandocfilters tornado jupyter_client
    defusedxml
    (nbclient.override { doCheck = false; }) # avoid infinite recursion
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
