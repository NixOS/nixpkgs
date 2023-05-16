{ lib
, buildPythonPackage
, fetchFromGitHub
, parameterized
, ply
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyomo";
<<<<<<< HEAD
  version = "6.6.2";
=======
  version = "6.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    repo = "pyomo";
    owner = "pyomo";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-hh2sfWOUp3ac75NEuTrw3YkvS7hXpzJp39v6cfrhNiQ=";
=======
    hash = "sha256-ZsoWz+35hQS15dbpe1IOzft6JwZygKjv5AQWjVe+8kQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    ply
  ];

  nativeCheckInputs = [
    parameterized
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyomo"
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  disabledTestPaths = [
    # Don't test the documentation and the examples
    "doc/"
    "examples/"
    # Tests don't work properly in the sandbox
    "pyomo/environ/tests/test_environ.py"
  ];

  disabledTests = [
    # Test requires lsb_release
    "test_get_os_version"
  ];

  meta = with lib; {
    description = "Python Optimization Modeling Objects";
    homepage = "http://pyomo.org";
    changelog = "https://github.com/Pyomo/pyomo/releases/tag/${version}";
    license = licenses.bsd3;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
