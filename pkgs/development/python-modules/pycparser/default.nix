{ stdenv, buildPythonPackage, fetchPypi, python }:

buildPythonPackage rec {
  pname = "pycparser";
  version = "2.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wvzyb6rxsfj3xcnpa4ynbh9qc7rrbk2277d5wqpphmx9akv8nbr";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest discover -s tests
  '';

  meta = with stdenv.lib; {
    description = "C parser in Python";
    homepage = https://github.com/eliben/pycparser;
    license = licenses.bsd3;
    maintainers = with maintainers; [ domenkozar ];
  };
}
