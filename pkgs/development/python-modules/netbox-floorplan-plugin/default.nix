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
  version = "0.7.0";
  pyproject = true;

  disabled = python.pythonVersion != netbox.python.pythonVersion;

  src = fetchFromGitHub {
    owner = "netbox-community";
    repo = "netbox-floorplan-plugin";
    tag = version;
    hash = "sha256-ecwPdcVuXU6OIVbafYGaY6+pbBHxhh1AlNmDBlUk1Ss=";
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

  meta = with lib; {
    description = "Netbox plugin providing floorplan mapping capability for locations and sites";
    homepage = "https://github.com/netbox-community/netbox-floorplan-plugin";
    changelog = "https://github.com/netbox-community/netbox-floorplan-plugin/releases/tag/${src.tag}";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ cobalt ];
  };
}
