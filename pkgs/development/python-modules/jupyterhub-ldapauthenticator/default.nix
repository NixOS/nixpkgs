{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  jupyterhub,
  ldap3,
  traitlets,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "jupyterhub-ldapauthenticator";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyterhub";
    repo = "ldapauthenticator";
    tag = version;
    hash = "sha256-xixgry/++E6RimB8wo1NF8SsfzxKL1ZlNQVrlBhQ674=";
  };

  build-system = [ setuptools ];

  dependencies = [
    jupyterhub
    ldap3
    traitlets
  ];

  pythonImportsCheck = [ "ldapauthenticator" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # touch the socket
    "test_allow_config"
    "test_ldap_auth"
  ];

  meta = with lib; {
    description = "Simple LDAP Authenticator Plugin for JupyterHub";
    homepage = "https://github.com/jupyterhub/ldapauthenticator";
    changelog = "https://github.com/jupyterhub/ldapauthenticator/blob/${version}/CHANGELOG.md";
    license = licenses.bsd3;
  };
}
