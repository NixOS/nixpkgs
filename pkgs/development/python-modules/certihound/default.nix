{
  lib,
  buildPythonPackage,
  fetchPypi,
  ldap3,
  impacket,
  cryptography,
  pydantic,
  click,
  rich,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "certihound";
  version = "0.3.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-uSoI4bz5h3Guy8TtfHjsk0zo9LNL2BJ5ZRFMFPk2Up0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    ldap3
    impacket
    cryptography
    pydantic
    click
    rich
  ];

  # Tests are stripped in pypi
  doCheck = false;

  pythonImportsCheck = [ "certihound" ];

  meta = {
    homepage = "https://github.com/0x0Trace/Certihound";
    description = "Active Directory Certificate Services (ADCS) enumeration library with BloodHound CE v6 export support";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ letgamer ];
  };
})
