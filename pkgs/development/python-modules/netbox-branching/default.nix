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
  pname = "netbox-branching";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netboxlabs";
    repo = "netbox-branching";
    tag = "v${version}";
    hash = "sha256-gAhZE/ICi3eq7Hn/8DDE2YI+9ayECD5s2UkXjUh+hig=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    django
    netaddr
    netbox
  ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  pythonImportsCheck = [ "netbox_branching" ];

  meta = {
    description = "Official NetBox Labs plugin that implements git-like branching functionality for NetBox";
    homepage = "https://github.com/netboxlabs/netbox-branching";
    changelog = "https://github.com/netboxlabs/netbox-branching/releases/tag/${src.tag}";
    license = lib.licenses.polyFormShield;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
