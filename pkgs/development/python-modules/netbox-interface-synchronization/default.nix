{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  netaddr,
  netbox,
  setuptools,
}:
buildPythonPackage rec {
  pname = "netbox-interface-synchronization";
  version = "4.1.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NetTech2001";
    repo = "netbox-interface-synchronization";
    tag = version;
    hash = "sha256-02fdfE1BwpWsh21M0oP65kMAbFxDxYHsAEWA64rUl18=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    netaddr
  ];

  # netbox is required for the pythonImportsCheck; plugin does not provide unit tests
  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  pythonImportsCheck = [ "netbox_interface_synchronization" ];

  meta = {
    description = "Netbox plugin to compare and synchronize interfaces between devices and device types";
    homepage = "https://github.com/NetTech2001/netbox-interface-synchronization";
    changelog = "https://github.com/NetTech2001/netbox-interface-synchronization/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
