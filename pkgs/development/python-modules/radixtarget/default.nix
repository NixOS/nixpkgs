{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  poetry-dynamic-versioning,
}:

buildPythonPackage rec {
  pname = "radixtarget";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "blacklanternsecurity";
    repo = "radixtarget";
    rev = "v${version}";
    hash = "sha256-C7QmiAc8SO7ddfseoGDYkmrkLoxmAGww9MPhBX94ucg=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "radixtarget" ];

  meta = {
    description = "Radix implementation designed for lookups of IP addresses/networks and DNS hostnames";
    homepage = "https://github.com/blacklanternsecurity/radixtarget";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
