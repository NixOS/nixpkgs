{ lib
, buildPythonPackage
, fetchPypi
, glibcLocales
, python
, isPy3k
}:

buildPythonPackage rec {
  pname = "PyPDF2";
  version = "2.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-WAKx9A+nm+G1q57claTn9+czmVidtPDmbKgx9Ennos0=";
  };

  LC_ALL = "en_US.UTF-8";
  buildInputs = [ glibcLocales ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover -s Tests
  '';

  # Tests broken on Python 3.x
  doCheck = !(isPy3k);

  meta = with lib; {
    description = "A Pure-Python library built as a PDF toolkit";
    homepage = "http://mstamy2.github.com/PyPDF2/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ desiderius vrthra ];
  };

}
