{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pythonOlder
, isPyPy
, lazy-object-proxy
, wrapt
, typing-extensions
, typed-ast
, pytestCheckHook
, setuptools-scm
, pylint
}:

buildPythonPackage rec {
  pname = "astroid";
  version = "2.8.2"; # Check whether the version is compatible with pylint

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = "v${version}";
    sha256 = "0140h4l7licwdw0scnfzsbi5b2ncxi7fxhdab7c1i3sk01r4asp6";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION=version;

  patches = [
    (fetchpatch {
      # Allow wrapt 1.13 (https://github.com/PyCQA/astroid/pull/1203)
      url = "https://github.com/PyCQA/astroid/commit/fd510e08c2ee862cd284861e02b9bcc9a7fd9809.patch";
      sha256 = "1s10whslcqnyz251fb76qkc9p41gagxljpljsmw89id1wywmjib4";
    })
  ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  # From astroid/__pkginfo__.py
  propagatedBuildInputs = [
    lazy-object-proxy
    wrapt
  ] ++ lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ] ++ lib.optional (!isPyPy && pythonOlder "3.8") typed-ast;

  checkInputs = [
    pytestCheckHook
  ];

  passthru.tests = {
    inherit pylint;
  };

  meta = with lib; {
    description = "An abstract syntax tree for Python with inference support";
    homepage = "https://github.com/PyCQA/astroid";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
}
