{
  lib,
  buildPythonPackage,
  python,
  fetchFromGitHub,
  setuptools,
  python-dateutil,
  drf-yasg,
  netbox,
  netaddr,
}:
buildPythonPackage rec {
  pname = "netbox-contract";
  version = "2.4.2";
  pyproject = true;

  disabled = python.pythonVersion != netbox.python.pythonVersion;

  src = fetchFromGitHub {
    owner = "mlebreuil";
    repo = "netbox-contract";
    tag = "v${version}";
    hash = "sha256-hJz6+vJWhwZJId5Otf1LaFkyaLncuuvai83aCu/aKu0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    python-dateutil
    drf-yasg
  ];

  # running tests requires initialized django project
  nativeCheckInputs = [
    netbox
    netaddr
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
