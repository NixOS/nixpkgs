{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netbox,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "netbox-bgp";
  version = "0.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netbox-community";
    repo = "netbox-bgp";
    rev = "v${version}";
    hash = "sha256-+F7Y+bmxVz/P1C8zG9Uev646zBKvlYOx/pENN1+4Dig=";
  };

  nativeBuildInputs = [ pytestCheckHook ];

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
