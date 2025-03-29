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
  version = "0.0.17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netbox-community";
    repo = "netbox-qrcode";
    tag = "v${version}";
    hash = "sha256-uJMGO9LXvaByfvrjNaPyY89Uaf71k1ku+/bfqc4npiQ=";
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
