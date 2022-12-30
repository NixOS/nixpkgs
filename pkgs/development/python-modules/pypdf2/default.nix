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
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-NA3Mf9Yq09xKEy3xNhfpwz8cTBU3mEbLle8UrsnxBvk=";
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
    homepage = "https://pypdf2.readthedocs.io/";
    changelog = "https://github.com/py-pdf/PyPDF2/raw/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ desiderius vrthra ];
  };

}
