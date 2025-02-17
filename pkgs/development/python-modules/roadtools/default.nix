{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  roadrecon,
  roadlib,
  roadtx,
}:

buildPythonPackage rec {
  pname = "roadtools";
  version = "0.0.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

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

  meta = with lib; {
    description = "Azure AD tooling framework";
    homepage = "https://github.com/dirkjanm/ROADtools";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
