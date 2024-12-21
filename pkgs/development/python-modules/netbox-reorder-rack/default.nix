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
  version = "1.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netbox-community";
    repo = "netbox-reorder-rack";
    rev = "refs/tags/v${version}";
    hash = "sha256-G1WGmEsKfz9HT6D6cCWJADm7pFaIV/jKYkYudEmUWJk=";
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
