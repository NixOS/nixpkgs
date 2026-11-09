{
  lib,
  aiohttp,
  bitstring,
  buildPythonPackage,
  fetchFromCodeberg,
  poetry-core,
  serialx,
}:

buildPythonPackage (finalAttrs: {
  pname = "pysml";
  version = "0.1.8";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "obi";
    repo = "pysml";
    tag = finalAttrs.version;
    hash = "sha256-EdFpRQar5C40GCficd+JH/hcumn9YOdkviONG39HdlE=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    bitstring
    serialx
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "sml" ];

  meta = {
    description = "Python library for EDL21 smart meters using Smart Message Language (SML)";
    homepage = "https://codeberg.org/obi/pysml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
