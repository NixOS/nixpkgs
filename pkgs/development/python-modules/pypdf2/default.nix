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
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-p0QI9pumJx9xuTUu9O0D3FOjGqQE0ptdMfU7/s/uFEA=";
  };

  LC_ALL = "en_US.UTF-8";
  buildInputs = [ glibcLocales ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ];

  nativeCheckInputs = [ unittestCheckHook ];

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
