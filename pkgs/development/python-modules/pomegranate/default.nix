{ stdenv, buildPythonPackage, fetchPypi, numpy, scipy, cython, networkx, joblib, nose }:

buildPythonPackage rec {
  pname = "pomegranate";
  version = "0.7.7";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b5b7a6256778fc4097ee77caec28ec845ec1fee3d701f3f26f83860b2d45c453";
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
