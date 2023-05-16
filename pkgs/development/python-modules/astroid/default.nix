{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, isPyPy
, lazy-object-proxy
, setuptools
<<<<<<< HEAD
, wheel
, typing-extensions
, typed-ast
, pip
=======
, typing-extensions
, typed-ast
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pylint
, pytestCheckHook
, wrapt
}:

buildPythonPackage rec {
  pname = "astroid";
<<<<<<< HEAD
  version = "2.15.6"; # Check whether the version is compatible with pylint
=======
  version = "2.14.2"; # Check whether the version is compatible with pylint
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7.2";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-0oNNEVD8rYGkM11nGUD+XMwE7xgk7mJIaplrAXaECFg=";
=======
    hash = "sha256-SIBzn57UNn/sLuDWt391M/kcCyjCocHmL5qi2cSX2iA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools
<<<<<<< HEAD
    wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    lazy-object-proxy
    wrapt
  ] ++ lib.optionals (pythonOlder "3.11") [
    typing-extensions
  ] ++ lib.optionals (!isPyPy && pythonOlder "3.8") [
    typed-ast
  ];

  nativeCheckInputs = [
<<<<<<< HEAD
    pip
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytestCheckHook
    typing-extensions
  ];

  disabledTests = [
    # DeprecationWarning: Deprecated call to `pkg_resources.declare_namespace('tests.testdata.python3.data.path_pkg_resources_1.package')`.
    "test_identify_old_namespace_package_protocol"
  ];

  passthru.tests = {
    inherit pylint;
  };

  meta = with lib; {
    changelog = "https://github.com/PyCQA/astroid/blob/${src.rev}/ChangeLog";
    description = "An abstract syntax tree for Python with inference support";
    homepage = "https://github.com/PyCQA/astroid";
    license = licenses.lgpl21Plus;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
