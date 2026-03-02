{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netbox,
  django,
  netaddr,
  python,
}:
buildPythonPackage rec {
  pname = "netbox-floorplan-plugin";
  version = "0.9.0";
  pyproject = true;

  disabled = python.pythonVersion != netbox.python.pythonVersion;

  src = fetchFromGitHub {
    owner = "netbox-community";
    repo = "netbox-floorplan-plugin";
    tag = version;
    hash = "sha256-soz6W/x4/lSBrH5kKOBOBlkPB353vpk4yJ333bvqx0k=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    netbox
    django
    netaddr
  ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  pythonImportsCheck = [ "netbox_floorplan" ];

  meta = {
    description = "Netbox plugin providing floorplan mapping capability for locations and sites";
    homepage = "https://github.com/netbox-community/netbox-floorplan-plugin";
    changelog = "https://github.com/netbox-community/netbox-floorplan-plugin/releases/tag/${src.tag}";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ cobalt ];
  };
}
