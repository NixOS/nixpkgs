{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  roadrecon,
  roadlib,
  roadtx,
}:

buildPythonPackage rec {
  pname = "roadtools";
  version = "0.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RxRbcT9uhQBYRDqq1asYDIwqrji14zi7dwRuQLXJiyQ=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
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
  };
}
