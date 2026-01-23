{
  lib,
  buildPythonPackage,
  setuptools-scm,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-xdist,
  numpy,
  numba,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "galois";
  version = "0.4.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mhostetter";
    repo = "galois";
    tag = "v${version}";
    hash = "sha256-0Fj/KYfR6SVfG7/uTo0mNrU1mv/QkKD8ja1dyDYVG/0=";
  };

  pythonRelaxDeps = [
    "numpy"
    "numba"
  ];

  build-system = [ setuptools-scm ];

  dependencies = [
    numpy
    numba
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  pythonImportsCheck = [ "galois" ];

  meta = {
    description = "Python package that extends NumPy arrays to operate over finite fields";
    homepage = "https://github.com/mhostetter/galois";
    changelog = "https://github.com/mhostetter/galois/releases/tag/${src.tag}";
    downloadPage = "https://github.com/mhostetter/galois/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chrispattison ];
  };
}
