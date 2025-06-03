{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  dnspython,
}:
buildPythonPackage rec {
  pname = "netbox-plugin-dns";
  version = "1.2.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "peteeckel";
    repo = "netbox-plugin-dns";
    tag = version;
    hash = "sha256-cT2nvPDsvZBVuhvvORtxwb2TDHqnSpvpIJFkGZy1CEc=";
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
