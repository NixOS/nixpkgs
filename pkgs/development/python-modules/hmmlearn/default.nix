{ lib, fetchurl, buildPythonPackage, numpy, scikitlearn, setuptools_scm, cython, pytest }:

buildPythonPackage rec {
  pname = "hmmlearn";
  version = "0.2.3";

  src = fetchurl {
    url = "mirror://pypi/h/hmmlearn/${pname}-${version}.tar.gz";
    sha256 = "8003d5dc55612de8016156abdc7aa1dd995abc2431adb1ef33dd84a6d29e56bf";
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
