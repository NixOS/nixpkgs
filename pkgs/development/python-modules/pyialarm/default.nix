{
  lib,
  buildPythonPackage,
  dicttoxml2,
  fetchFromGitHub,
  xmltodict,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyialarm";
  version = "2.2.0";

  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "RyuzakiKK";
    repo = "pyialarm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rOdeYewjoFVbHdNPHN6ZC2g6X5yr84/JFE6tGSDIoRU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    dicttoxml2
    xmltodict
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyialarm" ];

  meta = {
    description = "Python library to interface with Antifurto365 iAlarm systems";
    homepage = "https://github.com/RyuzakiKK/pyialarm";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
