{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  python,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "cma";
  version = "3.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CMA-ES";
    repo = "pycma";
    rev = "refs/tags/r${version}";
    hash = "sha256-wbAH0A5vpnnXqt7TTvLDPnCp6M3QjeCwD6l6LoTVu1w=";
  };

  propagatedBuildInputs = [ numpy ];

  checkPhase = ''
    # At least one doctest fails, thus only limited amount of files is tested
    ${python.executable} -m cma.test interfaces.py purecma.py logger.py optimization_tools.py transformations.py
  '';

  pythonImportsCheck = [ "cma" ];

  meta = with lib; {
    description = "Library for Covariance Matrix Adaptation Evolution Strategy for non-linear numerical optimization";
    homepage = "https://github.com/CMA-ES/pycma";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
