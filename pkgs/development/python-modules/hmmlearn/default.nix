{ lib, fetchurl, buildPythonPackage, numpy, scikitlearn, setuptools_scm, cython, pytest }:

buildPythonPackage rec {
  pname = "hmmlearn";
  version = "0.2.2";

  src = fetchurl {
    url = "mirror://pypi/h/hmmlearn/${pname}-${version}.tar.gz";
    sha256 = "081c53xs5wn5vikwslallwdv0am09w9cbbggl5dbkqpnic9zx4h4";
  };

  buildInputs = [ setuptools_scm cython ];
  propagatedBuildInputs = [ numpy scikitlearn ];
  checkInputs = [ pytest ];

  checkPhase = ''
    pytest --doctest-modules --pyargs hmmlearn
  '';

  meta = with lib; {
    description = "Hidden Markov Models in Python with scikit-learn like API";
    homepage    = https://github.com/hmmlearn/hmmlearn;
    license     = licenses.bsd3;
    maintainers = with maintainers; [ abbradar ];
  };
}
