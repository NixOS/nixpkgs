{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
}:

buildPythonPackage rec {
  pname = "latexrestricted";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/N5eC32OVN6qxWZAwAUlCIrMV2ARitiX3gaCPiSCRHs=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "latexrestricted" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    homepage = "https://github.com/gpoore/latexrestricted";
    description = "Python library for creating executables compatible with LaTeX restricted shell escape";
    changelog = "https://github.com/gpoore/latexrestricted/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.lppl13c;
    maintainers = with lib.maintainers; [ romildo ];
  };
}
