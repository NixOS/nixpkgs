{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netifaces,
}:

buildPythonPackage {
  pname = "pyeiscp";
  version = "1.1.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "winterscar";
    repo = "python-eiscp";
    tag = "v${version}"; # this is 0.0.7; tags are weird and from the original project this was forked from
    hash = "sha256-8K1rAHrhGGGaBJh2viHdYPgA61dfDSM0vaJKAvU+aQI=";
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
    maintainers = [ ];
  };
}
