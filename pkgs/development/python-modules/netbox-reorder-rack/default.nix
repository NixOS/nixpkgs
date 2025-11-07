{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netbox,
  python,
}:

buildPythonPackage rec {
  pname = "netbox-reorder-rack";
  version = "1.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netbox-community";
    repo = "netbox-reorder-rack";
    tag = "v${version}";
    hash = "sha256-lWC+Br66POJe3M8L+Pt5D1pWBr9qSpRLn2TcVMXKje4=";
  };

  build-system = [
    setuptools
  ];

  checkInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;
  pythonImportsCheck = [ "netbox_reorder_rack" ];

  meta = {
    description = "NetBox plugin to allow users to reorder devices within a rack using a drag and drop UI";
    homepage = "https://github.com/netbox-community/netbox-reorder-rack";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ minijackson ];
  };
}
