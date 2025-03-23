{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netifaces,
}:

buildPythonPackage {
  pname = "pyeiscp";
  version = "0.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "winterscar";
    repo = "python-eiscp";
    rev = "5f9ab5428ffa27a813dbfb00d392a0f76055137a"; # this is 0.0.7; tags are weird and from the original project this was forked from
    hash = "sha256-jmOPX0PnrKOs9kQZxlEpvp6Ck0kYXfWE6TgtKsOAHfs=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    netifaces
  ];

  doCheck = false; # no useful tests

  pythonImportsCheck = [
    "pyeiscp"
  ];

  meta = {
    description = "Python asyncio module to interface with Anthem AVM and MRX receivers";
    homepage = "https://github.com/winterscar/python-eiscp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
