{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  sh,
}:

buildPythonPackage rec {
  pname = "trevorproxy";
  version = "1.0.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZUOqtJmLiZbe2LBkpTGELeKFkmzA0WCJ/TXPi9eyRXs=";
  };

  build-system = [ poetry-core ];

  dependencies = [ sh ];

  pythonImportsCheck = [ "trevorproxy" ];

  meta = {
    description = "Module to rotate the source IP address via SSH proxies and other methods";
    homepage = "https://github.com/blacklanternsecurity/TREVORproxy";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "trevorproxy";
  };
}
