{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  bottle,
  proxy-tools,
  pyside6,
  qtpy,
  six,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pywebview";
  version = "6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "r0x0r";
    repo = "pywebview";
    tag = version;
    hash = "sha256-vqdJRxZbHNu2Sq318RnJjzDjYRRCSiO72WM+flKwW7g=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    bottle
    pyside6
    proxy-tools
    qtpy
    six
    typing-extensions
  ];

  pythonImportsCheck = [ "webview" ];

  meta = with lib; {
    description = "Lightweight cross-platform wrapper around a webview";
    homepage = "https://github.com/r0x0r/pywebview";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jojosch ];
  };
}
