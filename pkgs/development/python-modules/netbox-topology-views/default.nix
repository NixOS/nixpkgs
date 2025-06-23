{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netbox,
  pythonAtLeast,
  django,
  netaddr,
}:
buildPythonPackage rec {
  pname = "netbox-topology-views";
  version = "4.2.1";
  pyproject = true;

  disabled = pythonAtLeast "3.13";

  src = fetchFromGitHub {
    owner = "netbox-community";
    repo = "netbox-topology-views";
    tag = "v${version}";
    hash = "sha256-ysupqyRFOKVa+evNbfSdW2W57apI0jVEU92afz6+AaE=";
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

  pythonImportsCheck = [ "netbox_topology_views" ];

  meta = {
    description = "Netbox plugin for generate topology views/maps from your devices";
    homepage = "https://github.com/netbox-community/netbox-topology-views";
    changelog = "https://github.com/netbox-community/netbox-topology-views/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
