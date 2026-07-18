{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "cmdline";
  version = "0.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "7cf6af53549892b2218c2f56a199dff54a733be5c5515c0fd626812070b0a86a";
  };

  build-system = [ setuptools ];

  # No tests, https://github.com/rca/cmdline/issues/1
  doCheck = false;
  dependencies = [ pyyaml ];

  meta = {
    description = "Utilities for consistent command line tools";
    homepage = "https://github.com/rca/cmdline";
    license = lib.licenses.asl20;
  };
}
