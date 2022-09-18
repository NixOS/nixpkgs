{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, glibcLocales
, typing-extensions
, unittestCheckHook
, isPy3k
}:

buildPythonPackage rec {
  pname = "PyPDF2";
  version = "2.10.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8tpSVPBU6O+BDFMf4Rr28KQ2or4VmF7g0oho2GmOWj8=";
  };

  LC_ALL = "en_US.UTF-8";
  buildInputs = [ glibcLocales ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ];

  # Tests broken on Python 3.x
  #doCheck = !(isPy3k);

  checkInputs = [ unittestCheckHook ];

  meta = with lib; {
    description = "A Pure-Python library built as a PDF toolkit";
    homepage = "https://github.com/py-pdf/PyPDF2";
    changelog = "https://github.com/py-pdf/PyPDF2/raw/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ desiderius vrthra ];
  };

}
