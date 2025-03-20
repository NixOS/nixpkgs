{
  buildPythonPackage,
  chardet,
  charset-normalizer,
  click,
  fetchPypi,
  lib,
  opencv4,
  openpyxl,
  pandas,
  pdfminer-six,
  pkgs,
  pypdf,
  setuptools,
  tabulate,
}:

buildPythonPackage rec {
  pname = "camelot-py";
  version = "0.11.0";
  pyproject = true;

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

  build-system = [ setuptools ];

  dependencies = [
    chardet
    charset-normalizer
    click
    opencv4
    openpyxl
    pandas
    pdfminer-six
    pypdf
    tabulate
  ];

  doCheck = false;

  pythonImportsCheck = [ "camelot" ];

  meta = {
    description = "Python library to extract tabular data from PDFs";
    mainProgram = "camelot";
    homepage = "http://camelot-py.readthedocs.io";
    changelog = "https://github.com/camelot-dev/camelot/blob/v${version}/HISTORY.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ _2gn ];
  };
}
