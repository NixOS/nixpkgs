{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netbox,
  pytestCheckHook,
  python,
}:

buildPythonPackage rec {
  pname = "netbox-bgp";
  version = "0.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netbox-community";
    repo = "netbox-bgp";
    tag = "v${version}";
    hash = "sha256-2PJD/6WjFQRfreK2kpWIYXb5r4noJBa8zejK5r+A+xA=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;

  pythonImportsCheck = [ "netbox_bgp" ];

  meta = {
    description = "NetBox plugin for BGP related objects documentation";
    homepage = "https://github.com/netbox-community/netbox-bgp";
    changelog = "https://github.com/netbox-community/netbox-bgp/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
