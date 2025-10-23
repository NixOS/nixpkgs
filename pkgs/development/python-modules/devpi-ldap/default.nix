{
  lib,
  buildPythonPackage,
  devpi-server,
  fetchFromGitHub,
  ldap3,
  mock,
  pytest-cov-stub,
  pytest-flake8,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  setuptools,
  webtest,
}:

buildPythonPackage {
  pname = "devpi-ldap";
  version = "2.1.1-unstable-2023-11-28";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "devpi";
    repo = "devpi-ldap";
    rev = "281a21d4e8d11bfec7dca2cf23fa39660a6d5796";
    hash = "sha256-vwX0bOb2byN3M6iBk0tZJy8H39fjwBYvA0Nxi7OTzFQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    devpi-server
    pyyaml
    ldap3
  ];

  nativeCheckInputs = [
    devpi-server
    mock
    pytest-cov-stub
    pytest-flake8
    pytestCheckHook
    webtest
  ];

  pythonImportsCheck = [ "devpi_ldap" ];

  meta = {
    description = "LDAP authentication for devpi-server";
    homepage = "https://github.com/devpi/devpi-ldap";
    changelog = "https://github.com/devpi/devpi-ldap/blob/main/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ confus ];
  };
}
