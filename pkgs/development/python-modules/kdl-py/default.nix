{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "kdl-py";
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Y/P0bGJ33trc5E3PyUZyv25r8zMLkBIuATTCKFfimXM=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "kdl" ];

  checkPhase = ''
    runHook preCheck

    python tests/run.py

    runHook postCheck
  '';

  meta = {
    description = "Parser for the KDL language";
    homepage = "https://github.com/tabatkins/kdlpy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "kdlreformat";
  };
}
