{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  dnspython,
}:
buildPythonPackage rec {
  pname = "netbox-plugin-dns";
  version = "1.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "peteeckel";
    repo = "netbox-plugin-dns";
    tag = version;
    hash = "sha256-nQ7aN3YDANFK0kuTeoCF6Njg4s9AjtcSqAYz/ILtqd4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    dnspython
  ];

  # pythonImportsCheck fails due to improperly configured django app

  meta = {
    description = "Netbox plugin for managing DNS data";
    homepage = "https://github.com/peteeckel/netbox-plugin-dns";
    changelog = "https://github.com/peteeckel/netbox-plugin-dns/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
