{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  qrcode,
  pillow,
}:
buildPythonPackage rec {
  pname = "qrcode-terminal";
  version = "0.8";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Hitp5mK5NG6Y3ZWYMDPp1Dz/BkPYr9oSYF9RVCjmZsA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    qrcode
    pillow
  ];

  # have no test
  doCheck = false;

  pythonImportsCheck = [ "qrcode_terminal" ];

  meta = {
    description = "Display QRCode in Terminal";
    homepage = "https://github.com/alishtory/qrcode-terminal";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "qrcode-terminal-py";
  };
}
