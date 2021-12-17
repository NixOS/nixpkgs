{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, python
}:

buildPythonPackage rec {
  pname = "cma";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "CMA-ES";
    repo = "pycma";
    rev = "r${version}";
    sha256 = "1bal4kljxrdm6x5ppyi6i109714h0czdxfsna906dlfplrmq52bf";
  };

  propagatedBuildInputs = [
    numpy
  ];

  checkPhase = ''
    ${python.executable} -m cma.test
  '';

  meta = with lib; {
    description = "CMA-ES, Covariance Matrix Adaptation Evolution Strategy for non-linear numerical optimization in Python";
    homepage = "https://github.com/CMA-ES/pycma";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
