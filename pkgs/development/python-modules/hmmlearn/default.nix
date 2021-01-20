{ lib, fetchurl, buildPythonPackage, numpy, scikitlearn, setuptools_scm, cython, pytest }:

buildPythonPackage rec {
  pname = "hmmlearn";
  version = "0.2.4";

  src = fetchurl {
    url = "mirror://pypi/h/hmmlearn/${pname}-${version}.tar.gz";
    sha256 = "0f5cb598a7494b9703c6188246dc89e529d46cbb6700eca70cc895085f0b3cc3";
  };

  buildInputs = [ setuptools_scm cython ];
  propagatedBuildInputs = [ numpy scikitlearn ];
  checkInputs = [ pytest ];

  checkPhase = ''
    pytest --pyargs hmmlearn
  '';

  meta = with lib; {
    description = "Hidden Markov Models in Python with scikit-learn like API";
    homepage    = "https://github.com/hmmlearn/hmmlearn";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ abbradar ];
  };
}
