{
  lib,
  buildPythonPackage,
  cssselect,
  fetchPypi,
  lxml,
  pytestCheckHook,
  requests,
  setuptools,
  webob,
  webtest,
}:

buildPythonPackage rec {
  pname = "pyquery";
  version = "2.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AZS7JwaxLQN9sSxRko/p67NrctnnGVZdq6WmxZUyL68=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cssselect
    lxml
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "pyquery" ];

  nativeCheckInputs = [
    pytestCheckHook
    requests
    webob
    (webtest.overridePythonAttrs (_: {
      # circular dependency
      doCheck = false;
    }))
  ];

  disabledTestPaths = [
    # requires network
    "tests/test_pyquery.py::TestWebScrappingEncoding::test_get"
  ];

  disabledTests = [
    # broken in libxml 2.14 update
    # https://github.com/gawel/pyquery/issues/257
    "test_val_for_textarea"
    "test_replaceWith"
    "test_replaceWith_with_function"
    "test_get"
    "test_post"
    "test_session"
  ];

  meta = with lib; {
    description = "Jquery-like library for Python";
    homepage = "https://github.com/gawel/pyquery";
    changelog = "https://github.com/gawel/pyquery/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
  };
}
