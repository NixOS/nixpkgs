{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  pillow,
  qrcode,
  psycopg2,

  # nativeCheckInputs
  django,
  netaddr,
  netbox,
}:

buildPythonPackage (finalAttrs: {
  pname = "netbox-qrcode";
  version = "0.0.20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netbox-community";
    repo = "netbox-qrcode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7dPMpuJ2nuj9rRmVrfthD+xrEHoUaLFqDJWC6cGGCwY=";
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
    psycopg2 # not specified in pyproject.toml, but required at import time
  ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  pythonImportsCheck = [ "netbox_qrcode" ];

  meta = {
    description = "Netbox plugin for generate QR codes for objects: Rack, Device, Cable";
    homepage = "https://github.com/netbox-community/netbox-qrcode";
    changelog = "https://github.com/netbox-community/netbox-qrcode/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
