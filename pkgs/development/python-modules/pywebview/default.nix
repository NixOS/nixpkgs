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
  stdenv,
  pyobjc-core,
  pyobjc-framework-Cocoa,
  pyobjc-framework-Quartz,
  pyobjc-framework-Security,
  pyobjc-framework-WebKit,
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    pyobjc-core
    pyobjc-framework-Cocoa
    pyobjc-framework-Quartz
    pyobjc-framework-Security
    pyobjc-framework-WebKit
  ];

  pythonImportsCheck = [ "webview" ];

  meta = {
    description = "Lightweight cross-platform wrapper around a webview";
    homepage = "https://github.com/r0x0r/pywebview";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jojosch ];
  };
}
