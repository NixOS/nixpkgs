{ stdenv, buildPythonPackage, fetchFromGitHub, numpy, scipy, cython, networkx, joblib, nose, pyyaml }:

buildPythonPackage rec {
  pname = "pomegranate";
  version = "0.11.2";

  src = fetchFromGitHub {
    repo = pname;
    owner = "jmschrei";
    rev = "v${version}";
    sha256 = "070ciwww1lhjmfwd5n1kcwgxwbgdfvmhjs4l156bnf08z9dlrafl";
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
