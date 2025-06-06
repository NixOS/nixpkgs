{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  addict,
  regex,
}:

buildPythonPackage rec {
  pname = "misaki";
  version = "0.9.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OWD6Pm3heakO6OYoRGpKT2uMcwtuNBCZnPOWGJ9NnEA=";
  };

  build-system = [ hatchling ];

  buildInputs = [
    addict
    regex
  ];

  pythonImportsCheck = [ "misaki" ];

  meta = {
    description = "G2P engine designed for Kokoro models";
    homepage = "https://pypi.org/project/misaki";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ emaryn ];
  };
}
