{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pillow,
  appdirs,
  argcomplete,
  pyserial,
  pyusb,
  pyyaml,
  qrcode,
  six,
  setuptools-scm,
  python-barcode,
  importlib-resources,
}:

buildPythonPackage rec {
  pname = "python-escpos";
  version = "3.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MSQM3UOm0zccLFNvjewC8xv2julnzS7bJVqUz2cpWsA=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    pillow
    appdirs
    argcomplete
    pyserial
    pyusb
    pyyaml
    qrcode
    six
    python-barcode
    importlib-resources
  ];

  pythonImportsCheck = [ "escpos" ];

  meta = with lib; {
    description = "Python library to manipulate ESC/POS printers";
    homepage = "https://github.com/python-escpos/python-escpos";
    changelog = "https://github.com/python-escpos/python-escpos/blob/v${version}/CHANGELOG.rst";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ JeppeX ];
  };
}
