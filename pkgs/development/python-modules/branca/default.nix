{ lib
, buildPythonPackage
, fetchFromGitHub
, jinja2
, pytestCheckHook
, pythonOlder
, setuptools-scm
, selenium
}:

buildPythonPackage rec {
  pname = "branca";
  version = "0.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-visualization";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-bcqr+vGKBga4rR4XFRWbjtw5xL+pWkIt+ihtKlKF6Y8=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  postPatch = ''
    # We don't want flake8
    rm setup.cfg
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    jinja2
  ];

  nativeCheckInputs = [
    pytestCheckHook
    selenium
  ];

  pythonImportsCheck = [
    "branca"
  ];

  disabledTestPaths = [
    # Some tests require a browser
    "tests/test_utilities.py"
  ];

  disabledTests = [
    "test_rendering_utf8_iframe"
    "test_rendering_figure_notebook"
  ];

  meta = with lib; {
    description = "Generate complex HTML+JS pages with Python";
    homepage = "https://github.com/python-visualization/branca";
    changelog = "https://github.com/python-visualization/branca/blob/v${version}/CHANGES.txt";
    license = with licenses; [ mit ];
    maintainers = with lib.maintainers; [ ];
  };
}
