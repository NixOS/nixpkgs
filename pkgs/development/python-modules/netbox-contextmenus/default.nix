{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netbox,
  python,
}:

buildPythonPackage rec {
  pname = "netbox-contextmenus";
  version = "1.4.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PieterL75";
    repo = "netbox_contextmenus";
    tag = "v${version}";
    hash = "sha256-xgJ9EzdLc2xK9Kam8fS3f9bEgWq2O7NFx3D8Ci3Hc8o=";
  };

  build-system = [ setuptools ];

  # pythonImportsCheck fails due to improperly configured django app

  meta = {
    description = "Netbox plugin to add context buttons to the links, making navigating less clicky";
    homepage = "https://github.com/PieterL75/netbox_contextmenus/";
    changelog = "https://github.com/PieterL75/netbox_contextmenus/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
