{
  buildPythonPackage,
  chardet,
  charset-normalizer,
  click,
  fetchPypi,
  ghostscript,
  lib,
  opencv4,
  openpyxl,
  pandas,
  pdfminer-six,
  pkgs,
  pypdf,
  pythonOlder,
  setuptools,
  tabulate,
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

  patches = [ ./ghostscript.patch ];

  postPatch = ''
    substituteInPlace camelot/backends/ghostscript_backend.py \
      --replace-fail 'find_library("gs")' '""' \
      --replace-fail '@ghostscript@' ${lib.getExe pkgs.ghostscript_headless}
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    chardet
    charset-normalizer
    click
    ghostscript
    opencv4
    openpyxl
    pandas
    pdfminer-six
    pypdf
    tabulate
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
