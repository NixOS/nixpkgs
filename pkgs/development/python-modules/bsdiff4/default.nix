{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "bsdiff4";
  version = "1.2.6";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-KrV9AaeLOeKeWszJz+rUEwmC3tncy8QmG9DpxR1rdR0=";
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
