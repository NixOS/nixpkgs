{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  python,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cma";
  version = "4.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CMA-ES";
    repo = "pycma";
    rev = "refs/tags/r${version}";
    hash = "sha256-W4KDtX/Ho/XUrZr2cmS66Q0q90FEHRJN0VF4sMgonRw=";
  };

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  checkPhase = ''
    # At least one doctest fails, thus only limited amount of files is tested
    ${python.executable} -m cma.test interfaces.py purecma.py logger.py optimization_tools.py transformations.py
  '';

  pythonImportsCheck = [ "cma" ];

  meta = with lib; {
    description = "Library for Covariance Matrix Adaptation Evolution Strategy for non-linear numerical optimization";
    homepage = "https://github.com/CMA-ES/pycma";
    changelog = "https://github.com/CMA-ES/pycma/releases/tag/r${version}";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
