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
  version = "0.3.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mhostetter";
    repo = "galois";
    rev = "refs/tags/v${version}";
    hash = "sha256-nlNy4+GwStyuCD8f47w07NhNmepxBRtu6PXiL31vzwA=";
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

  meta = {
    description = "A Python 3 package that extends NumPy arrays to operate over finite fields";
    homepage = "https://github.com/mhostetter/galois";
    downloadPage = "https://github.com/mhostetter/galois/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chrispattison ];
  };
}
