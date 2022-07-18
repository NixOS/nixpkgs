{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonAtLeast
, pythonOlder
, isPyPy
, lazy-object-proxy
, setuptools
, setuptools-scm
, typing-extensions
, typed-ast
, pylint
, pytestCheckHook
, wrapt
}:

buildPythonPackage rec {
  pname = "astroid";
  version = "2.11.5"; # Check whether the version is compatible with pylint

  disabled = pythonOlder "3.6.2";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GKda3hNdOrsd11pi+6NpYodW4TAgSvqbv2hF4GaIvtM=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    lazy-object-proxy
    setuptools
    wrapt
  ] ++ lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ] ++ lib.optionals (!isPyPy && pythonOlder "3.8") [
    typed-ast
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # AssertionError: Lists differ: ['ABC[16 chars]yBase', 'Final', 'Generic', 'MyProtocol', 'Protocol', 'object'] != ['ABC[16 chars]yBase', 'Final', 'Generic', 'MyProtocol', 'object']
    "test_mro_typing_extensions"
  ];

  passthru.tests = {
    inherit pylint;
  };

  meta = with lib; {
    description = "An abstract syntax tree for Python with inference support";
    homepage = "https://github.com/PyCQA/astroid";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
