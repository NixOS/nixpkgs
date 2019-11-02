{ stdenv, buildPythonPackage, fetchFromGitHub, numpy, scipy, cython, networkx, joblib, nose, pyyaml }:

buildPythonPackage rec {
  pname = "pomegranate";
  version = "0.11.1";

  src = fetchFromGitHub {
    repo = pname;
    owner = "jmschrei";
    rev = "v${version}";
    sha256 = "19kdzqyj86aldsls68a6ymrs8sasv3a8r4wjmfdmcif1xsg6zb4q";
  };

  propagatedBuildInputs = [ numpy scipy cython networkx joblib pyyaml ];

  checkInputs = [ nose ];

  meta = with stdenv.lib; {
    description = "Probabilistic and graphical models for Python, implemented in cython for speed";
    homepage = https://github.com/jmschrei/pomegranate;
    license = licenses.mit;
    maintainers = with maintainers; [ rybern ];
  };
}
