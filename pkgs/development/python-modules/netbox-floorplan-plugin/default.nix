{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netbox,
  pythonAtLeast,
}:
buildPythonPackage rec {
  pname = "netbox-floorplan-plugin";
  version = "0.6.0";
  pyproject = true;

  disabled = pythonAtLeast "3.13";

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
    changelog = "https://github.com/netbox-community/netbox-floorplan-plugin/releases/tag/${src.tag}";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ cobalt ];
  };
}
