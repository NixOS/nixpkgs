{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, glibcLocales
, typing-extensions
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "PyPDF2";
  version = "2.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2IF2H2xjEJqFkJPJHckKFdAf816s3rkoCTYLliPiw8k=";
  };

  LC_ALL = "en_US.UTF-8";
  buildInputs = [ glibcLocales ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ];

  checkInputs = [ unittestCheckHook ];

  pythonImportsCheck = [
    "PyPDF2"
  ];

  meta = with lib; {
    description = "A Pure-Python library built as a PDF toolkit";
    homepage = "https://github.com/py-pdf/PyPDF2";
    changelog = "https://github.com/py-pdf/PyPDF2/raw/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ desiderius vrthra ];
  };

}
