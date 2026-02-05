{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  toml,
  zipp,

  # Reverse dependency
  sage,
}:

buildPythonPackage rec {
  pname = "importlib-metadata";
  version = "8.7.0";
  pyproject = true;

  src = fetchPypi {
    pname = "importlib_metadata";
    inherit version;
    hash = "sha256-0TuBrSI7iQqhbFRx8qwwVs92xfEPgtb5KS8LQV84kAA=";
  };

  build-system = [
    setuptools # otherwise cross build fails
    setuptools-scm
  ];

  dependencies = [
    toml
    zipp
  ];

  # Cyclic dependencies due to pyflakefs
  doCheck = false;

  pythonImportsCheck = [ "importlib_metadata" ];

  passthru.tests = {
    inherit sage;
  };

  meta = {
    description = "Read metadata from Python packages";
    homepage = "https://importlib-metadata.readthedocs.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      fab
    ];
  };
}
