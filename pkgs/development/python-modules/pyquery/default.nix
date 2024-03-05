{ lib
, buildPythonPackage
, cssselect
, fetchPypi
, lxml
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, requests
, webob
, webtest
}:

buildPythonPackage rec {
  pname = "pyquery";
  version = "2.0.0";
  disabled = pythonOlder "3.7";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lj6NTpAmL/bY3sBy6pcoXcN0ovacrXd29AgqvPah2K4=";
  };

  # https://github.com/gawel/pyquery/issues/248
  postPatch = ''
    substituteInPlace tests/test_pyquery.py \
      --replace test_selector_html skip_test_selector_html
  '';

  propagatedBuildInputs = [
    cssselect
    lxml
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "pyquery" ];

  checkInputs = [
    pytestCheckHook
    requests
    webob
    (webtest.overridePythonAttrs (_: {
      # circular dependency
      doCheck = false;
    }))
  ];

  pytestFlagsArray = [
    # requires network
    "--deselect=tests/test_pyquery.py::TestWebScrappingEncoding::test_get"
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.12") [
    # https://github.com/gawel/pyquery/issues/249
    "pyquery.pyquery.PyQuery.serialize_dict"
  ];

  meta = with lib; {
    description = "A jquery-like library for Python";
    homepage = "https://github.com/gawel/pyquery";
    changelog = "https://github.com/gawel/pyquery/blob/${version}/CHANGES.rst";
    license = licenses.bsd0;
  };
}
