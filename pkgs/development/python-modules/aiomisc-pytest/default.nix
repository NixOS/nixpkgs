{
  lib,
  aiomisc,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pytest,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiomisc-pytest";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "aiomisc_pytest";
    inherit (finalAttrs) version;
    hash = "sha256-cbYrkO6YRSPFfhjgdXzuVA2wY5RyEmWcG+myGZu1TGU=";
  };

  pythonRelaxDeps = [ "pytest" ];

  build-system = [ hatchling ];

  buildInputs = [ pytest ];

  dependencies = [ aiomisc ];

  pythonImportsCheck = [ "aiomisc_pytest" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Pytest integration for aiomisc";
    homepage = "https://github.com/aiokitchen/aiomisc-pytest";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
