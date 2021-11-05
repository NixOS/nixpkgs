{ lib
, buildPythonPackage
, isPy27
, fetchpatch
, setuptools-scm
, libdeltachat
, cffi
, imapclient
, pluggy
, requests
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "deltachat";
  inherit (libdeltachat) version src;
  sourceRoot = "${src.name}/python";

  disabled = isPy27;

  nativeBuildInputs = [
    setuptools-scm
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  buildInputs = [
    libdeltachat
  ];

  propagatedBuildInputs = [
    cffi
    imapclient
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
