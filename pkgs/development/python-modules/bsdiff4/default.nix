{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "bsdiff4";
  version = "1.4.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-P/1Niy1bnw8cQn5PtYUS3IikzIB2I7crwOleC6ohxws=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "bsdiff4" ];

  checkPhase = ''
    mv bsdiff4 _bsdiff4
    python -c 'import bsdiff4; bsdiff4.test()'
  '';

  meta = {
    description = "Binary diff and patch using the BSDIFF4-format";
    homepage = "https://github.com/ilanschnell/bsdiff4";
    changelog = "https://github.com/ilanschnell/bsdiff4/blob/${finalAttrs.version}/CHANGELOG.txt";
    license = lib.licenses.bsdProtection;
    maintainers = with lib.maintainers; [ ris ];
  };
})
