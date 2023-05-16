{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
<<<<<<< HEAD
=======
, six
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "repeated-test";
<<<<<<< HEAD
  version = "2.3.3";
=======
  version = "2.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    pname = "repeated_test";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-3YPU8SL9rud5s0pnwwH5TJk1MXsDhdkDnZp/Oj6sgXs=";
=======
    hash = "sha256-TbVyQA7EjCSwo6qfDksbE8IU1ElkSCABEUBWy5j1KJc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

<<<<<<< HEAD
=======
  propagatedBuildInputs = [
    six
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "repeated_test"
  ];

  meta = with lib; {
    description = "Unittest-compatible framework for repeating a test function over many fixtures";
    homepage = "https://github.com/epsy/repeated_test";
<<<<<<< HEAD
    changelog = "https://github.com/epsy/repeated_test/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ tjni ];
  };
}
