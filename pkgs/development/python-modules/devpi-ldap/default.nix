{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  devpi-server,
  pyyaml,
  ldap3,
}:

buildPythonPackage rec {
  pname = "devpi-ldap";
  version = "2.1.1";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "devpi";
    repo = "devpi-ldap";
    tag = version;
    hash = "sha256-Upz6+pCS+8fStHkt5+q9uuawc8IOkZNppjnnnxa4wW4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    devpi-server
    pyyaml
    ldap3
  ];

  pythonImportsCheck = [ "devpi_ldap" ];

  meta = {
    homepage = "https://github.com/devpi/devpi-ldap";
    description = "LDAP authentication for devpi-server";
    changelog = "https://github.com/devpi/devpi-ldap/blob/main/CHANGELOG.rst";
    license = lib.licenses.mit; # according to its setup.py
    maintainers = with lib.maintainers; [ confus ];
  };
}
