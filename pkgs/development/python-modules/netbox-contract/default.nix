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
buildPythonPackage (finalAttrs: {
  pname = "netbox-contract";
  version = "2.4.5";
  pyproject = true;

  disabled = python.pythonVersion != netbox.python.pythonVersion;

  src = fetchFromGitHub {
    owner = "mlebreuil";
    repo = "netbox-contract";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+6dw8vPDNItZRfExL0C5ul2XghoToMHotEAH90B3CmE=";
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
    changelog = "https://github.com/mlebreuil/netbox-contract/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
