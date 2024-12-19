{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
  six,
}:

buildPythonPackage rec {
  pname = "markdownify";
  version = "0.14.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "matthewwithanm";
    repo = "python-markdownify";
    rev = "refs/tags/${version}";
    hash = "sha256-YJdR1wV72f9/tWQhuhGwScuRcE243fCP+wnYAzBOoV8=";
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
