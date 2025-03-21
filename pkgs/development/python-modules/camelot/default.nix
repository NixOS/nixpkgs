{
  buildPythonPackage,
  chardet,
  charset-normalizer,
  click,
  fetchPypi,
  lib,
  opencv-python-headless,
  openpyxl,
  pandas,
  pdfminer-six,
  pillow,
  pkgs,
  pypdf,
  pypdfium2,
  setuptools,
  tabulate,
}:

buildPythonPackage rec {
  pname = "camelot-py";
  version = "1.0.9";
  pyproject = true;

  src = fetchPypi {
    pname = "camelot_py";
    inherit version;
    hash = "sha256-1D2Idm98NGKAP/EUZOfT0VqSI+hFly3ith73w/YtMgA=";
  };

  patches = [ ./ghostscript.patch ];

  postPatch = ''
    substituteInPlace camelot/backends/ghostscript_backend.py \
      --replace-fail '@ghostscript@' ${lib.getExe pkgs.ghostscript_headless}
  '';

  pythonRelaxDeps = [ "pypdf" ];

  build-system = [ setuptools ];

  dependencies = [
    chardet
    charset-normalizer
    click
    opencv-python-headless
    openpyxl
    pandas
    pdfminer-six
    pillow
    pypdf
    pypdfium2
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
