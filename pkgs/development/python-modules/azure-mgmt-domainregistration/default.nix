{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  azure-mgmt-core,
  isodate,
  typing-extensions,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-mgmt-domainregistration";
  version = "1.0.0b1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "azure_mgmt_domainregistration";
    inherit (finalAttrs) version;
    hash = "sha256-9ayRrmCqmTY8yMLtrj/IIUb5xONb9SQoz8wvN29Wvy0=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    azure-mgmt-core
    isodate
    typing-extensions
  ];

  pythonImportsCheck = [
    "azure.mgmt.domainregistration"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "This package will be released in the near future. Stay tuned";
    homepage = "https://pypi.org/project/azure-mgmt-domainregistration";
    license = lib.licenses.mit;
    maintainers = [ ];
    hasNoMaintainersButDependents = true;
  };
})
