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
  version = "0.3.5";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mhostetter";
    repo = "galois";
    rev = "refs/tags/v${version}";
    hash = "sha256-4eYDaQwjnYCTnobXRtFrToRyxxH2N2n9sh8z7oPC2Wc=";
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
    changelog = "https://github.com/mhostetter/galois/releases/tag/v${version}";
    downloadPage = "https://github.com/mhostetter/galois/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ chrispattison ];
  };
}
