{ lib, fetchurl, buildPythonPackage, numpy, scikit-learn, setuptools-scm, cython, pytest }:

buildPythonPackage rec {
  pname = "hmmlearn";
  version = "0.2.5";

  src = fetchurl {
    url = "mirror://pypi/h/hmmlearn/${pname}-${version}.tar.gz";
    sha256 = "14fb4ad3fb7529785844a25fae5d32272619fb5973cc02c8784018055470ca01";
  };

  buildInputs = [ setuptools-scm cython ];
  propagatedBuildInputs = [ numpy scikit-learn ];
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
