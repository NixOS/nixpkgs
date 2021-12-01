{ lib, fetchurl, buildPythonPackage, numpy, scikit-learn, setuptools-scm, cython, pytest }:

buildPythonPackage rec {
  pname = "hmmlearn";
  version = "0.2.6";

  src = fetchurl {
    url = "mirror://pypi/h/hmmlearn/${pname}-${version}.tar.gz";
    sha256 = "2a289cf28b31be59fa8ba5d3253d4a2a992401d45a8cdc221ae484fbf390c0d7";
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
