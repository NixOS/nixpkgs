{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "anyascii";
  version = "0.3.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yU6d2dR7PZSU7KMF/vlEfQC0vxoyr/hap0b6Psf7lcM=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    changelog = "https://github.com/anyascii/anyascii/blob/${version}/CHANGELOG.md";
    description = "Unicode to ASCII transliteration";
    homepage = "https://github.com/anyascii/anyascii";
    license = licenses.isc;
    teams = [ teams.tts ];
  };
}
