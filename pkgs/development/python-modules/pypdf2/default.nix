{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  pythonOlder,
  typing-extensions,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "pypdf2";
  version = "3.0.1";

  format = "pyproject";

  src = fetchPypi {
    pname = "PyPDF2";
    inherit version;
    hash = "sha256-p0QI9pumJx9xuTUu9O0D3FOjGqQE0ptdMfU7/s/uFEA=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.10") [ typing-extensions ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "PyPDF2" ];

  meta = with lib; {
    description = "A Pure-Python library built as a PDF toolkit";
    homepage = "https://pypdf2.readthedocs.io/";
    changelog = "https://github.com/py-pdf/PyPDF2/raw/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      desiderius
      vrthra
    ];
  };
}
