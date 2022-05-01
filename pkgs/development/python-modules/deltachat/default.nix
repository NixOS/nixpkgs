{ lib
, buildPythonPackage
, isPy27
, pkg-config
, pkgconfig
, setuptools-scm
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

  disabled = isPy27;

  nativeBuildInputs = [
    pkg-config
    pkgconfig
    setuptools-scm
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
    setuptools
  ];

  checkInputs = [
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
    maintainers = with maintainers; [ dotlambda ];
  };
}
