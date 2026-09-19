{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-rust,
  rustPlatform,
}:
buildPythonPackage rec {
  pname = "gel";
  version = "3.1.0b1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LsfT63Jv+rxPkZDbxurY0MrLy4J+nC836aGyh5i9p/k=";
  };

  build-system = [
    setuptools
    setuptools-rust
  ];

  dependencies = [];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    # Resolved from the first worker build log (standard fakeHash flow);
    # whether the sdist even needs cargo is unproven until then.
    hash = lib.fakeHash;
  };

  nativeBuildInputs = [rustPlatform.cargoSetupHook];

  pythonImportsCheck = ["gel"];

  meta = {
    description = "Python client for Gel (used by gel-server)";
    homepage = "https://github.com/geldata/gel-python";
    license = lib.licenses.asl20;
    # The sdist build path is unproven; the worker build is authoritative.
    broken = false;
  };
}
