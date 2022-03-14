{ lib, fetchurl, buildPythonPackage, numpy, scikit-learn, setuptools-scm, cython, pytest }:

buildPythonPackage rec {
  pname = "hmmlearn";
  version = "0.2.7";

  src = fetchurl {
    url = "mirror://pypi/h/hmmlearn/${pname}-${version}.tar.gz";
    sha256 = "sha256-a0snIPJ6912pNnq02Q3LAPONozFo322Rf57F3mZw9uE=";
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
