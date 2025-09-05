{
  buildPythonPackage,
  chardet,
  charset-normalizer,
  click,
  fetchPypi,
  ghostscript,
  lib,
  opencv-python-headless,
  openpyxl,
  pandas,
  pdfminer-six,
  pkgs,
  pypdf,
  pypdfium2,
  pythonOlder,
  setuptools,
  tabulate,
}:

buildPythonPackage rec {
  pname = "camelot-py";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "camelot_py";
    inherit version;
    hash = "sha256-YlFL2e/67zmjTIUPSwlwWoF74WBIOwKMyM3hSVRyFGY=";
  };

  patches = [ ./ghostscript.patch ];

  postPatch = ''
    substituteInPlace camelot/backends/ghostscript_backend.py \
      --replace-fail '@ghostscript@' ${lib.getExe pkgs.ghostscript_headless}
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    chardet
    charset-normalizer
    click
    ghostscript
    opencv-python-headless
    openpyxl
    pandas
    pdfminer-six
    pypdf
    pypdfium2
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
