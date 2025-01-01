{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  pillow,
  qrcode,
  netbox,
}:
buildPythonPackage rec {
  pname = "netbox-qrcode";
  version = "0.0.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netbox-community";
    repo = "netbox-qrcode";
    rev = "v${version}";
    hash = "sha256-gEBOjmX7dcLjiy0u6raAtAaqZUVYsPz3YhupjRRqVDE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    qrcode
    pillow
  ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  pythonImportsCheck = [ "netbox_qrcode" ];

  meta = {
    description = "Netbox plugin for generate QR codes for objects: Rack, Device, Cable.";
    homepage = "https://github.com/netbox-community/netbox-qrcode";
    changelog = "https://github.com/netbox-community/netbox-qrcode/releases/tag/${src.rev}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
