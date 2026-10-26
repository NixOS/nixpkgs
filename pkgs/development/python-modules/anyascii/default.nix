{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "anyascii";
  version = "0.3.3";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-yU6d2dR7PZSU7KMF/vlEfQC0vxoyr/hap0b6Psf7lcM=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/anyascii/anyascii/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Unicode to ASCII transliteration";
    homepage = "https://github.com/anyascii/anyascii";
    license = lib.licenses.isc;
    teams = [ lib.teams.tts ];
  };
})
