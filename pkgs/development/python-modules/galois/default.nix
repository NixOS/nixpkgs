{ lib
, buildPythonPackage
, setuptools-scm
, pythonOlder
, pythonRelaxDepsHook
, fetchFromGitHub
, pytestCheckHook
, pytest-xdist
, numpy
, numba
, typing-extensions
}:

buildPythonPackage rec {
  pname = "galois";
<<<<<<< HEAD
  version = "0.3.5";
=======
  version = "0.3.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mhostetter";
    repo = "galois";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-4eYDaQwjnYCTnobXRtFrToRyxxH2N2n9sh8z7oPC2Wc=";
=======
    hash = "sha256-yvF57ErcaknKcK6UgINt65uASNZpEtXk+LOizYDH1Bo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    numpy
    numba
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  pythonRelaxDeps = [ "numpy" "numba" ];

  pythonImportsCheck = [ "galois" ];

  meta = with lib; {
    description = "Python package that extends NumPy arrays to operate over finite fields";
    homepage = "https://github.com/mhostetter/galois";
<<<<<<< HEAD
    changelog = "https://github.com/mhostetter/galois/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    downloadPage = "https://github.com/mhostetter/galois/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ chrispattison ];
  };
}
