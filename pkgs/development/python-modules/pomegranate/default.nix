{ stdenv, buildPythonPackage, fetchPypi, numpy, scipy, cython, networkx, joblib, nose }:

buildPythonPackage rec {
  pname = "pomegranate";
  version = "0.8.0";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6b03d05bffbe46c674800652cf273a8d338a2e40001b763cd6925aac0b578a43";
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
