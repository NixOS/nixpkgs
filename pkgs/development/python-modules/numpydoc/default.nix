{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  jinja2,
  sphinx,
  tabulate,

  # tests
  matplotlib,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "numpydoc";
  version = "1.8.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname;
    inherit version;
    hash = "sha256-AiOQq3RkpE+HN/efizHOHTz6S0r3nMqhqsXoNo21h/s=";
  };

  build-system = [ setuptools ];

  dependencies = [
    jinja2
    sphinx
    tabulate
  ];

  nativeCheckInputs = [
    matplotlib
    pytest-cov-stub
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/numpy/numpydoc/issues/373
    "test_MyClass"
    "test_my_function"

    # AttributeError: 'MockApp' object has no attribute '_exception_on_warning'
    "test_mangle_docstring_validation_exclude"
    "test_mangle_docstring_validation_warnings"
    "test_mangle_docstrings_overrides"
  ];

  pythonImportsCheck = [ "numpydoc" ];

  meta = {
    changelog = "https://github.com/numpy/numpydoc/releases/tag/v${version}";
    description = "Sphinx extension to support docstrings in Numpy format";
    mainProgram = "validate-docstrings";
    homepage = "https://github.com/numpy/numpydoc";
    license = lib.licenses.free;
  };
}
