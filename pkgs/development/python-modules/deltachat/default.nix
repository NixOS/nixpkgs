{
  lib,
  buildPythonPackage,
  pythonOlder,
  pkg-config,
  pkgconfig,
  setuptools-scm,
  libdeltachat,
  cffi,
  imap-tools,
  requests,
  pluggy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "deltachat";
  inherit (libdeltachat) version src;
  sourceRoot = "${src.name}/python";

  disabled = pythonOlder "3.7";
  pyproject = true;

  nativeBuildInputs = [
    cffi
    pkg-config
    pkgconfig
    setuptools-scm
  ];

  buildInputs = [ libdeltachat ];

  propagatedBuildInputs = [
    cffi
    imap-tools
    pluggy
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "deltachat"
    "deltachat.account"
    "deltachat.contact"
    "deltachat.chat"
    "deltachat.message"
  ];

  meta = libdeltachat.meta // {
    description = "Python bindings for the Delta Chat Core library";
    homepage = "https://github.com/deltachat/deltachat-core-rust/tree/master/python";
  };
}
