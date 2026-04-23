{
  buildPythonPackage,
  fetchPypi,
  flit-core,
  lib,
}:

buildPythonPackage rec {
  pname = "pypdf2";
  version = "3.0.1";

  pyproject = true;

  src = fetchPypi {
    pname = "PyPDF2";
    inherit version;
    hash = "sha256-p0QI9pumJx9xuTUu9O0D3FOjGqQE0ptdMfU7/s/uFEA=";
  };

  nativeBuildInputs = [ flit-core ];

  # no test
  doCheck = false;

  pythonImportsCheck = [ "PyPDF2" ];

  meta = {
    description = "Pure-Python library built as a PDF toolkit";
    homepage = "https://pypdf2.readthedocs.io/";
    changelog = "https://github.com/py-pdf/PyPDF2/raw/${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
  };
}
