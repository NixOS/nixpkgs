{ lib
, buildPythonPackage
, pythonOlder
, pkg-config
, pkgconfig
, setuptools-scm
, wheel
, libdeltachat
, cffi
, imap-tools
, requests
, pluggy
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "deltachat";
  inherit (libdeltachat) version src;
  sourceRoot = "${src.name}/python";

  disabled = pythonOlder "3.7";
  format = "pyproject";

  nativeBuildInputs = [
    cffi
    pkg-config
    pkgconfig
    setuptools
    setuptools-scm
    wheel
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  buildInputs = [
    libdeltachat
  ];

  propagatedBuildInputs = [
    cffi
    imap-tools
    pluggy
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "deltachat"
    "deltachat.account"
    "deltachat.contact"
    "deltachat.chat"
    "deltachat.message"
  ];

  meta = with lib; {
    description = "Python bindings for the Delta Chat Core library";
    homepage = "https://github.com/deltachat/deltachat-core-rust/tree/master/python";
    changelog = "https://github.com/deltachat/deltachat-core-rust/blob/${version}/python/CHANGELOG";
    license = licenses.mpl20;
    maintainers = with maintainers; [ dotlambda srapenne ];
  };
}
