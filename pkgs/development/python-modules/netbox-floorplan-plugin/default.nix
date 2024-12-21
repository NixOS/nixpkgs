{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netbox,
}:
buildPythonPackage rec {
  pname = "netbox-floorplan-plugin";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netbox-community";
    repo = "netbox-floorplan-plugin";
    tag = version;
    hash = "sha256-cJrqSXRCBedZh/pIozz/bHyhQosTy8cFYyji3KJva9Q=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  pythonImportsCheck = [ "netbox_floorplan" ];

  meta = with lib; {
    description = "Netbox plugin providing floorplan mapping capability for locations and sites";
    homepage = "https://github.com/netbox-community/netbox-floorplan-plugin";
    changelog = "https://github.com/netbox-community/netbox-floorplan-plugin/releases/tag/${src.rev}";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ cobalt ];
  };
}
