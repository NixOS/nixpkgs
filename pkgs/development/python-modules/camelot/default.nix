{
  lib,
  buildPythonPackage,
  chardet,
  openpyxl,
  charset-normalizer,
  fetchPypi,
  pythonOlder,
  pandas,
  tabulate,
  click,
  pdfminer-six,
  pypdf,
  opencv4,
  setuptools,
}:

buildPythonPackage rec {
  pname = "camelot-py";
  version = "0.11.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-l6fZBtaF5AWaSlSaY646UfCrcqPIJlV/hEPGWhGB3+Y=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    charset-normalizer
    chardet
    pandas
    tabulate
    click
    pdfminer-six
    openpyxl
    pypdf
    opencv4
  ];

  doCheck = false;

  pythonImportsCheck = [ "camelot" ];

  meta = with lib; {
    description = "Python library to extract tabular data from PDFs";
    mainProgram = "camelot";
    homepage = "http://camelot-py.readthedocs.io";
    changelog = "https://github.com/camelot-dev/camelot/blob/v${version}/HISTORY.md";
    license = licenses.mit;
    maintainers = with maintainers; [ _2gn ];
  };
}
