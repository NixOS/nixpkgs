{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:
buildPythonPackage rec {
  pname = "parsing";
  version = "2.0.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CP8ZQhU2be/qJuiys2Q2PNzQ0+RktCsdSbuGx2QspQQ=";
  };

  build-system = [setuptools];

  # Pure-Python PEG parser library; no runtime dependencies.
  dependencies = [];

  pythonImportsCheck = ["parsing"];

  meta = {
    description = "PEG parser library for Python";
    homepage = "https://github.com/MagicStack/parsing";
    license = lib.licenses.asl20;
  };
}
