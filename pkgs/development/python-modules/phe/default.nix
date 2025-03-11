{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPyPy,
  isPy3k,
  setuptools,
  click,
  gmpy2,
  pytestCheckHook,
  numpy,
}:

buildPythonPackage rec {
  pname = "phe";
  version = "1.5.1";
  pyproject = true;

  # https://github.com/data61/python-paillier/issues/51
  disabled = isPyPy || !isPy3k;

  src = fetchFromGitHub {
    owner = "data61";
    repo = "python-paillier";
    tag = version;
    hash = "sha256-P//4ZL4+2zcB5sWvujs2N0CHFz+EBLERWrPGLLHj6CY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    gmpy2 # optional, but major speed improvement
  ];

  nativeCheckInputs = [
    pytestCheckHook
    numpy
  ];

  meta = with lib; {
    description = "Library for Partially Homomorphic Encryption in Python";
    mainProgram = "pheutil";
    homepage = "https://github.com/data61/python-paillier";
    license = licenses.gpl3;
    maintainers = with maintainers; [ tomasajt ];
  };
}
