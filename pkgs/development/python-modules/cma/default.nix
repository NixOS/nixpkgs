{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, python
}:

buildPythonPackage rec {
  pname = "cma";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "CMA-ES";
    repo = "pycma";
    rev = "r${version}";
    sha256 = "0c26969pcqj047axksfffd9pj77n16k4r9h6pyid9q3ah5zk0xg3";
  };

  propagatedBuildInputs = [
    numpy
  ];

  checkPhase = ''
    ${python.executable} -m cma.test
  '';

  meta = with lib; {
    description = "CMA-ES, Covariance Matrix Adaptation Evolution Strategy for non-linear numerical optimization in Python";
    homepage = https://github.com/CMA-ES/pycma;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
