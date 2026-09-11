{
  lib,
  buildPythonPackage,
  fetchPypi,
  impacket,
  ldap3,
  nix-update-script,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "ldap3-ad-auth";
  version = "0.1.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "ldap3_ad_auth";
    inherit (finalAttrs) version;
    hash = "sha256-2z6/xApwr5Vz59FJMzF9T3WlFyfU/HWNo8RnOALTjOA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    impacket
    ldap3
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ldap3_ad_auth" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Protected AD LDAP authentication for ldap3";
    homepage = "https://pypi.org/project/ldap3-ad-auth";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
