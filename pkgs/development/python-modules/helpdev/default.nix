{
  lib,
  buildPythonPackage,
  fetchPypi,
  importlib-metadata,
  psutil,
  setuptools,
}:

buildPythonPackage rec {
  pname = "helpdev";
  version = "0.7.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gfvj28i82va7c264jl2p4cdsl3lpf9fpb9cyjnis55crfdafqmv";
  };

  build-system = [ setuptools ];

  dependencies = [
    importlib-metadata
    psutil
  ];

  # No tests included in archive
  doCheck = false;

  meta = {
    description = "Extracts information about the Python environment easily";
    mainProgram = "helpdev";
    license = lib.licenses.mit;
  };
}
