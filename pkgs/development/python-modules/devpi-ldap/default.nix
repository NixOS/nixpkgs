{
  lib,
  buildPythonPackage,
  devpi-server,
  fetchFromGitHub,
  ldap3,
  mock,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  pythonAtLeast,
  pyyaml,
  setuptools,
  setuptools-changelog-shortener,
  webtest,
}:

buildPythonPackage (finalAttrs: {
  pname = "devpi-ldap";
  version = "2.1.1-unstable-2026-01-22";
  pyproject = true;

  # build-system broken for 3.14, package incompatible <3.13
  disabled = pythonOlder "3.13" || pythonAtLeast "3.14";

  src = fetchFromGitHub {
    owner = "devpi";
    repo = "devpi-ldap";
    rev = "5846e66a9206079c16321bd0f65c565ebe32be5f";
    hash = "sha256-2LpreWmG6WMRrc5L7ylSej5Ce6VhfNDAW2eoJ76D49o=";
  };

  build-system = [
    setuptools
    setuptools-changelog-shortener
  ];

  dependencies = [
    devpi-server
    pyyaml
    ldap3
  ];

  nativeCheckInputs = [
    devpi-server
    mock
    pytest-cov-stub
    pytestCheckHook
    webtest
  ];

  pythonImportsCheck = [ "devpi_ldap" ];

  meta = {
    description = "LDAP authentication for devpi-server";
    homepage = "https://github.com/devpi/devpi-ldap";
    changelog = "https://github.com/devpi/devpi-ldap/blob/${finalAttrs.src.rev}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ confus ];
  };
})
