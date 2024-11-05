{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
  six,
}:

buildPythonPackage rec {
  pname = "markdownify";
  version = "0.13.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qyV/nmvUB1EYgoooydAvikv+t0IfVYg0qnmy3+syoJg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    beautifulsoup4
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "markdownify" ];

  meta = with lib; {
    description = "HTML to Markdown converter";
    homepage = "https://github.com/matthewwithanm/python-markdownify";
    changelog = "https://github.com/matthewwithanm/python-markdownify/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ McSinyx ];
    mainProgram = "markdownify";
  };
}
