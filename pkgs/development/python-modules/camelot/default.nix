{ lib
, stdenv
, buildPythonPackage
, chardet
, openpyxl
, charset-normalizer
, fetchPypi
, fetchpatch
, pythonOlder
, pandas
, tabulate
, click
, pdfminer
, pypdf
, opencv3
}:

buildPythonPackage rec {
  pname = "camelot-py";
  version = "0.11.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-l6fZBtaF5AWaSlSaY646UfCrcqPIJlV/hEPGWhGB3+Y=";
  };

  propagatedBuildInputs = [
    charset-normalizer
    chardet
    pandas
    tabulate
    click
    pdfminer
    openpyxl
    pypdf
    opencv3
  ];

  doCheck = false;

  pythonImportsCheck = [
    "camelot"
  ];

  meta = with lib; {
    description = "A Python library to extract tabular data from PDFs";
    homepage = "http://camelot-py.readthedocs.io";
    changelog = "https://github.com/camelot-dev/camelot/blob/v${version}/HISTORY.md";
    license = licenses.mit;
    maintainers = with maintainers; [ _2gn ];
  };
}
