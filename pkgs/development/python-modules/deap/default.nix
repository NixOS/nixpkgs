{ stdenv, buildPythonPackage, fetchPypi, python, numpy, matplotlib }:

buildPythonPackage rec {
  pname = "deap";
  version = "1.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "95c63e66d755ec206c80fdb2908851c0bef420ee8651ad7be4f0578e9e909bcf";
  };

  propagatedBuildInputs = [ numpy matplotlib ];

  checkPhase = ''
    ${python.interpreter} setup.py nosetests --verbosity=3
  '';

  meta = with stdenv.lib; {
    description = "DEAP is a novel evolutionary computation framework for rapid prototyping and testing of ideas.";
    homepage = https://github.com/DEAP/deap;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ psyanticy ];
  };

}

