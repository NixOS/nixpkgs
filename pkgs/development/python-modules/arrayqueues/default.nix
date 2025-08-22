{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "arrayqueues";
  version = "1.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7I+5BQO/gsvTREDkBfxrMblw3JPfY48S4KI4PCGPtFY=";
  };

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  meta = {
    homepage = "https://github.com/portugueslab/arrayqueues";
    description = "Multiprocessing queues for numpy arrays using shared memory";
    changelog = "https://github.com/portugueslab/arrayqueues/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tbenst ];
  };
}
