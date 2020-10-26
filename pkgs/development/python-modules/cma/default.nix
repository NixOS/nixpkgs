{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, python
}:

buildPythonPackage rec {
  pname = "cma";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "CMA-ES";
    repo = "pycma";
    rev = "r${version}";
    sha256 = "00vv7imdkv0bqcs4b8dg9nggxcl2fkcnhdd46n22bcmnwy8rjxv6";
  };

  propagatedBuildInputs = [
    numpy
  ];

  checkPhase = ''
    ${python.executable} -m cma.test
  '';

  meta = with lib; {
    broken = true;
    description = "CMA-ES, Covariance Matrix Adaptation Evolution Strategy for non-linear numerical optimization in Python";
    homepage = "https://github.com/CMA-ES/pycma";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
