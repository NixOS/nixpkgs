{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  aiocoap,
  pycryptodome,
}:

buildPythonPackage rec {
  pname = "eris";
  version = "1.0.0";
  pyproject = true;
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aiPmf759Cd3SeKfQtqgszcKkhZPM4dNY2x9YxJFPRh0=";
  };
  build-system = [ setuptools ];
  dependencies = [
    aiocoap
    pycryptodome
  ];
  meta = {
    description = "Python implementation of the Encoding for Robust Immutable Storage (ERIS)";
    homepage = "https://eris.codeberg.page/python-eris/";
    license = [ lib.licenses.agpl3Plus ];
    maintainers = with lib.maintainers; [ ehmry ];
  };
}
