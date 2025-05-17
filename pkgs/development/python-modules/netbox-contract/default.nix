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
  version = "2.4.0";
  pyproject = true;

  disabled = pythonAtLeast "3.13";

  src = fetchFromGitHub {
    owner = "mlebreuil";
    repo = "netbox-contract";
    tag = "v${version}";
    hash = "sha256-duA53cuJ3q6CRp239xNMXQhGZHGn7IBIGNLoxt7hZh8=";
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
    changelog = "https://github.com/mlebreuil/netbox-contract/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
