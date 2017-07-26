{ lib, fetchurl, buildPythonPackage, numpy }:

buildPythonPackage rec {
  name = "hmmlearn-${version}";
  version = "0.2.0";

  src = fetchurl {
    url = "mirror://pypi/h/hmmlearn/${name}.tar.gz";
    sha256 = "0qc3fkdyrgfg31y1a8jzs83dxkjw78pqkdm44lll1iib63w4cik9";
  };

  propagatedBuildInputs = [ numpy ];

  doCheck = false;

  meta = with lib; {
    description = "Hidden Markov Models in Python with scikit-learn like API";
    homepage    = "https://github.com/hmmlearn/hmmlearn";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ abbradar ];
    platforms   = platforms.unix;
  };
}
