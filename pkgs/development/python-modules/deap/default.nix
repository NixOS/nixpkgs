{ stdenv, buildPythonPackage, fetchPypi, python, numpy, matplotlib }:

buildPythonPackage rec {
  pname = "deap";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bvshly83c4h5jhxaa97z192viczymz5fxp6vl8awjmmrs9l9x8i";
  };

  propagatedBuildInputs = [ numpy matplotlib ];

  checkPhase = ''
    ${python.interpreter} setup.py nosetests --verbosity=3
  '';

  meta = with stdenv.lib; {
    description = "DEAP is a novel evolutionary computation framework for rapid prototyping and testing of ideas.";
    homepage = "https://github.com/DEAP/deap";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ psyanticy ];
  };

}

