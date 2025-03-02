{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  netaddr,
  netbox,
  pillow,
  qrcode,
  setuptools,
}:

buildPythonPackage rec {
  pname = "netbox-qrcode";
  version = "0.0.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netbox-community";
    repo = "netbox-qrcode";
    tag = "v${version}";
    hash = "sha256-3d2UugM08qGW5YnpxYVp9FfgMTevJaExAnTpaKwxcUw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    qrcode
    pillow
  ];

  nativeCheckInputs = [
    django
    netaddr
    netbox
  ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  pythonImportsCheck = [ "netbox_qrcode" ];

  meta = {
    description = "Netbox plugin for generate QR codes for objects: Rack, Device, Cable.";
    homepage = "https://github.com/netbox-community/netbox-qrcode";
    changelog = "https://github.com/netbox-community/netbox-qrcode/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
