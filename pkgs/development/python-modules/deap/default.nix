{ stdenv, buildPythonPackage, fetchPypi, python, numpy, matplotlib }:

buildPythonPackage rec {
  pname = "deap";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "102r11pxb36xkq5bjv1lpkss77v278f5xdv6lvkbjdvqryydf3yd";
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

