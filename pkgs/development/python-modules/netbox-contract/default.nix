{
  lib,
  buildPythonPackage,
  pythonAtLeast,
  fetchFromGitHub,
  setuptools,
  python-dateutil,
  drf-yasg,
  netbox,
}:
buildPythonPackage rec {
  pname = "netbox-contract";
  version = "2.3.2";
  pyproject = true;

  disabled = pythonAtLeast "3.13";

  src = fetchFromGitHub {
    owner = "mlebreuil";
    repo = "netbox-contract";
    tag = "v${version}";
    hash = "sha256-e3N0m+oj2CMUXwI4dF/tXA+Lz+9+ZlbJAy+zHoRDNtw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    python-dateutil
    drf-yasg
  ];

  # running tests requires initialized django project
  nativeCheckInputs = [
    netbox
  ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  pythonImportsCheck = [ "netbox_contract" ];

  meta = {
    description = "Contract plugin for netbox";
    homepage = "https://github.com/mlebreuil/netbox-contract";
    changelog = "https://github.com/mlebreuil/netbox-contract/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
