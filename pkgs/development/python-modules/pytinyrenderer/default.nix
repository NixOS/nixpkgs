{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytinyrenderer";
  version = "0.0.14";
  pyproject = true;

  # github has no tags
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-X+20eYUJy5EaA6O8no3o1NWqNrHeUuuHjv7xBLlaPRU=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "pytinyrenderer"
  ];

  # There are no tests in the pypi archive
  doCheck = false;

  meta = {
    description = "Python bindings for Tiny Renderer";
    homepage = "https://pypi.org/project/pytinyrenderer/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
