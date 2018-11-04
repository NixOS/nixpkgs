{ stdenv, buildPythonPackage, fetchPypi, python }:

buildPythonPackage rec {
  pname = "pycparser";
  version = "2.19";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3";
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
