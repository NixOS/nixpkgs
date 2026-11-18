{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-cloud-translate,
  mtranslate,
  nix-update-script,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "roundtrip";
  version = "0.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-HRIkp0MIHg5PCBJZeco5y5POoGjLyonkm7QTan98+4A=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-cloud-translate
    mtranslate
  ];

  pythonImportsCheck = [ "roundtrip" ];

  # Module has no tests
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Round trip translation for NLP data augmentation";
    homepage = "https://pypi.org/project/roundtrip";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
