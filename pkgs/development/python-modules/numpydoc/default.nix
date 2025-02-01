{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy27,
  setuptools,
  jinja2,
  sphinx,
  tabulate,
  pytestCheckHook,
  matplotlib,
}:

buildPythonPackage rec {
  pname = "numpydoc";
  version = "1.7.0";
  pyproject = true;

  disabled = isPy27;

  src = fetchPypi {
    inherit pname;
    inherit version;
    hash = "sha256-hm5a5bZQnc+HP8Y4ESD1wxrPE7E1Y2wagdaMFmqV+SE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov-report=" "" \
      --replace "--cov=numpydoc" ""
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    jinja2
    sphinx
    tabulate
  ];

  nativeCheckInputs = [
    matplotlib
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/numpy/numpydoc/issues/373
    "test_MyClass"
    "test_my_function"
    "test_reference"
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
