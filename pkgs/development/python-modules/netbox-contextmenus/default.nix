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
  version = "1.4.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PieterL75";
    repo = "netbox_contextmenus";
    tag = "v${version}";
    hash = "sha256-wK8IQ+vYFP9cWcazTOzP1eoKBU0YXwbQrtfM7tGNTXI=";
  };

  build-system = [ setuptools ];

  # pythonImportsCheck fails due to improperly configured django app

  meta = {
    description = "Netbox plugin to add context buttons to the links, making navigating less clicky";
    homepage = "https://github.com/PieterL75/netbox_contextmenus/";
    changelog = "https://github.com/PieterL75/netbox_contextmenus/releases/tag/${src.tag}";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
