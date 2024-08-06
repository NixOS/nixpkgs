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
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netbox-community";
    repo = "netbox-reorder-rack";
    rev = "v${version}";
    hash = "sha256-rmGByfh/rX/1wMN8cHBhvuntId2wLn2rYgPDzQqvxBM=";
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

  meta = with lib; {
    description = "NetBox plugin to allow users to reorder devices within a rack using a drag and drop UI";
    homepage = "https://github.com/minitriga/netbox-reorder-rack/";
    license = licenses.asl20;
    maintainers = with maintainers; [ minijackson ];
  };
}
