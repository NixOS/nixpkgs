{ stdenv, buildPythonPackage, fetchFromGitHub, numpy, scipy, cython, networkx, joblib, nose }:

buildPythonPackage rec {
  pname = "pomegranate";
  version = "0.8.1";
  name  = "${pname}-${version}";
  
  src = fetchFromGitHub {
    repo = pname;
    owner = "jmschrei";
    rev = "v${version}";
    sha256 = "085nka5bh88bxbd5vl1azyv9cfpp6grz2ngclc85f9kgccac1djr";
  };

  propagatedBuildInputs = [ numpy scipy cython networkx joblib ];

  checkInputs = [ nose ];

  meta = with stdenv.lib; {
    description = "Probabilistic and graphical models for Python, implemented in cython for speed";
    homepage = https://github.com/jmschrei/pomegranate;
    license = licenses.mit;
    maintainers = with maintainers; [ rybern ];
  };
}
