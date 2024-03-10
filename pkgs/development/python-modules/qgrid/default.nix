{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, ipywidgets
, notebook
, pandas
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "qgrid";
  version = "1.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/or1tQgzCE3AtqJlzRrHuDfAPA+FIRUBY1YNzneNcRw=";
  };

  patches = [
    # Fixes compatibility of qgrid with ipywidgets >= 8.0.0
    # See https://github.com/quantopian/qgrid/pull/331
    (fetchpatch {
      url = "https://github.com/quantopian/qgrid/pull/331/commits/8cc50d5117d4208a9dd672418021c59898e2d1b2.patch";
      hash = "sha256-+NLz4yBUGUXKyukPVE4PehenPzjnfljR5RAX7CEtpV4=";
    })
  ];

  propagatedBuildInputs = [
    ipywidgets
    notebook
    pandas
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Those tests are also failing upstream
  disabledTests = [
    "test_edit_date"
    "test_edit_multi_index_df"
    "test_multi_index"
    "test_period_object_column"
    # probably incompatible with pandas>=2.1
    "test_add_row_button"
  ];

  pythonImportsCheck = [ "qgrid" ];

  meta = with lib; {
    description = "An interactive grid for sorting, filtering, and editing DataFrames in Jupyter notebooks";
    homepage = "https://github.com/quantopian/qgrid";
    license = licenses.asl20;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
