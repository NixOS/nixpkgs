{ stdenv
, buildPythonPackage
, fetchPypi
, glibcLocales
, python
, isPy3k
}:

buildPythonPackage rec {
  pname = "PyPDF2";
  version = "1.26.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11a3aqljg4sawjijkvzhs3irpw0y67zivqpbjpm065ha5wpr13z2";
  };

  LC_ALL = "en_US.UTF-8";
  buildInputs = [ glibcLocales ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover -s Tests
  '';

  # Tests broken on Python 3.x
  doCheck = !(isPy3k);

  meta = with stdenv.lib; {
    description = "A Pure-Python library built as a PDF toolkit";
    homepage = "http://mstamy2.github.com/PyPDF2/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ desiderius vrthra ];
  };

}
