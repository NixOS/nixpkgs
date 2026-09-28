{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  azure-common,
  azure-mgmt-nspkg,
  requests,
  msrestazure,
  setuptools,
  isPy3k,
}:

buildPythonPackage (finalAttrs: {
  version = "0.20.0";
  pyproject = true;

  __structuredAttrs = true;
  pname = "azure-mgmt-common";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    extension = "zip";
    hash = "sha256-xjgSwT2fNmFcB/h0vGArczu1FvHtYqtzGJuPcca/v+Y=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-nspkg
    requests
    msrestazure
  ];

  postInstall = lib.optionalString (!isPy3k) ''
    echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/${python.sitePackages}"/azure/mgmt/__init__.py
    echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/${python.sitePackages}"/azure/__init__.py
  '';

  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.common" ];

  meta = {
    description = "This is the Microsoft Azure Resource Management common code";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      olcai
      maxwilson
    ];
  };
})
