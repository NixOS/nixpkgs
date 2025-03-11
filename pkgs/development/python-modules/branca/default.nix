{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jinja2,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
  selenium,
}:

buildPythonPackage rec {
  pname = "branca";
  version = "0.8.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-visualization";
    repo = "branca";
    tag = "v${version}";
    hash = "sha256-Gnr3ONqWpUNOGiOlyq77d9PxcDT8TjqTHYBGxH+V+xc=";
  };

  postPatch = ''
    # We don't want flake8
    rm setup.cfg
  '';

  build-system = [ setuptools-scm ];

  dependencies = [ jinja2 ];

  nativeCheckInputs = [
    pytestCheckHook
    selenium
  ];

  pythonImportsCheck = [ "branca" ];

  disabledTestPaths = [
    # Some tests require a browser
    "tests/test_utilities.py"
    "tests/test_iframe.py"
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
    maintainers = [ ];
  };
}
