{ lib, fetchurl, buildPythonPackage, numpy, scikitlearn }:

buildPythonPackage rec {
  pname = "hmmlearn";
  version = "0.2.1";
  name = pname + "-" + version;

  src = fetchurl {
    url = "mirror://pypi/h/hmmlearn/${name}.tar.gz";
    sha256 = "d43f5b25f9019ef5d01914d0972a5fa0594e82ab75d2c6aec26d682e47bd553c";
  };

  propagatedBuildInputs = [ numpy scikitlearn ];

  doCheck = false;

  meta = with lib; {
    description = "Hidden Markov Models in Python with scikit-learn like API";
    homepage    = https://github.com/hmmlearn/hmmlearn;
    license     = licenses.bsd3;
    maintainers = with maintainers; [ abbradar ];
  };
}
