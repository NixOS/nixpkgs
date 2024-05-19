{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netbox,
}:

buildPythonPackage rec {
  pname = "netbox-bgp";
  version = "0.11.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "netbox-community";
    repo = "netbox-bgp";
    rev = "v${version}";
    hash = "sha256-T/+/JxY9Oyf7e70yK8X/ZaENYbV0f0YmGYtaEmnvhgI";
  };

  build-system = [ setuptools ];

  checkInputs = [ netbox ];

  meta = {
    description = "NetBox plugin for BGP related objects documentation";
    homepage = "https://github.com/netbox-community/netbox-bgp";
    changelog = "https://github.com/netbox-community/netbox-bgp/releases/tag/${src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
