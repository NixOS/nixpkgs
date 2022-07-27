{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, glibcLocales
, typing-extensions
, python
, isPy3k
}:

buildPythonPackage rec {
  pname = "PyPDF2";
  version = "2.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ad39ck3f4HAQ7zpWyVvxIYVT7Anig2Nuzw8HLsEZWZo=";
  };

  LC_ALL = "en_US.UTF-8";
  buildInputs = [ glibcLocales ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  # Tests broken on Python 3.x
  #doCheck = !(isPy3k);

  meta = with lib; {
    description = "A Pure-Python library built as a PDF toolkit";
    homepage = "http://mstamy2.github.com/PyPDF2/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ desiderius vrthra ];
  };

}
