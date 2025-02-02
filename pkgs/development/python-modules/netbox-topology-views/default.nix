{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netbox,
  pythonAtLeast,
}:
buildPythonPackage rec {
  pname = "netbox-topology-views";
  version = "4.1.0";
  pyproject = true;

  disabled = pythonAtLeast "3.13";

  src = fetchFromGitHub {
    owner = "netbox-community";
    repo = "netbox-topology-views";
    rev = "v${version}";
    hash = "sha256-4ehIF6r4fCgBAaHImzofdQIywtD7ITQFP6DkHXHKMro=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  pythonImportsCheck = [ "netbox_topology_views" ];

  meta = {
    description = "Netbox plugin for generate topology views/maps from your devices";
    homepage = "https://github.com/netbox-community/netbox-topology-views";
    changelog = "https://github.com/netbox-community/netbox-topology-views/releases/tag/${src.rev}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
