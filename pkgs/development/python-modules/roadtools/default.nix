{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  roadrecon,
  roadlib,
  roadtx,
}:

buildPythonPackage (finalAttrs: {
  pname = "roadtools";
  version = "0.0.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-RxRbcT9uhQBYRDqq1asYDIwqrji14zi7dwRuQLXJiyQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    roadrecon
    roadlib
    roadtx
  ];

  pythonImportsCheck = [ "roadtools" ];

  meta = {
    description = "Azure AD tooling framework";
    homepage = "https://github.com/dirkjanm/ROADtools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "roadtools";
  };
})
